#include <linux/init.h>
#include <linux/module.h>
#include <linux/uaccess.h>
#include <linux/fs.h>
#include <linux/proc_fs.h>

// Module metadata
MODULE_AUTHOR("TDK");
MODULE_DESCRIPTION("ROOTKIT");
MODULE_LICENSE("GPL");

// Custom init and exit methods
static int __init custom_init(void) {
 printk(KERN_INFO "rootkit ok");
 return 0;
}

static void __exit custom_exit(void) {
 printk(KERN_INFO "Bye bye rootkit");
}

module_init(custom_init);
module_exit(custom_exit);