--- src/os/unix/process-wrappers.c.orig	2024-04-08 08:32:00 UTC
+++ src/os/unix/process-wrappers.c
@@ -28,6 +28,10 @@
 #include <unistd.h>
 #include <sys/wait.h>
 #include <signal.h>
+#ifdef __NetBSD__
+#include <sys/select.h>
+#include <sys/time.h>
+#endif
 
 typedef long long int sint_64;
 
