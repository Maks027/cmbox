/*
 * Minimal newlib syscall stubs (the rest come from --specs=nosys.specs).
 * Implement _write() here to retarget printf() to a UART / SWO / RTT.
 */
#include <errno.h>

int _close(int fd)
{
    (void)fd;
    errno = EBADF;
    return -1;
}

int _lseek(int fd, int offset, int whence)
{
    (void)fd; (void)offset; (void)whence;
    return 0;
}

int _read(int fd, char *buf, int len)
{
    (void)fd; (void)buf; (void)len;
    return 0;
}

int _write(int fd, const char *buf, int len)
{
    (void)fd; (void)buf;
    return len;
}
