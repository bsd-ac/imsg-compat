/* $OpenBSD: imsg_init.3,v 1.23 2019/01/20 02:50:03 bcook Exp $
 *
 * Copyright (c) 2010 Nicholas Marriott <nicm@openbsd.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF MIND, USE, DATA OR PROFITS, WHETHER
 * IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING
 * OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

// based on the example given in the OpenBSD manpage - imsg_init.3

#include <err.h>
#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/queue.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/uio.h>
#include <unistd.h>

#include "imsg.h"

enum imsg_type { IMSG_A_MESSAGE, IMSG_MESSAGE2 };

#define DATA_VALUE 42

int dispatch_imsg(struct imsgbuf *ibuf) {
  struct imsg imsg;
  ssize_t n;
  uint16_t datalen;
  int idata;

  if (((n = imsg_read(ibuf)) == -1 && errno != EAGAIN) || n == 0) {
    return -1;
  }

  for (;;) {
    if ((n = imsg_get(ibuf, &imsg)) == -1) {
      return -1;
    }
    if (n == 0) /* no more messages */
      return -1;
    datalen = imsg.hdr.len - IMSG_HEADER_SIZE;

    switch (imsg.hdr.type) {
    case IMSG_A_MESSAGE:
      if (datalen < sizeof idata) {
        return -1;
      }
      memcpy(&idata, imsg.data, sizeof idata);
      /* handle message received */
      if (idata == DATA_VALUE)
        return 0;
      else
        return -1;
      break;
    }

    imsg_free(&imsg);
  }
  return -1;
}

int child_main(struct imsgbuf *ibuf) {
  int idata;
  idata = DATA_VALUE;
  imsg_compose(ibuf, IMSG_A_MESSAGE, 0, 0, -1, &idata, sizeof idata);
  if (msgbuf_write(&ibuf->w) == -1 && errno != EAGAIN) {
    return -1;
  }
  return 0;
}

int parent_main(struct imsgbuf *ibuf) { return dispatch_imsg(ibuf); }

int main(void) {
  struct imsgbuf parent_ibuf, child_ibuf;
  int imsg_fds[2];

  if (socketpair(AF_UNIX, SOCK_STREAM, PF_UNSPEC, imsg_fds) == -1)
    err(1, "socketpair");

  switch (fork()) {
  case -1:
    err(1, "fork");
  case 0:
    /* child */
    close(imsg_fds[0]);
    imsg_init(&child_ibuf, imsg_fds[1]);
    exit(child_main(&child_ibuf));
  }

  /* parent */
  close(imsg_fds[1]);
  imsg_init(&parent_ibuf, imsg_fds[0]);
  exit(parent_main(&parent_ibuf));

  return 0; // never reached
}
