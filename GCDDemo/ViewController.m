//
//  ViewController.m
//  GCDDemo
//
//  Created by xt on 2018/12/18.
//  Copyright © 2018 TJ. All rights reserved.
//
/*
 dispatch [dɪ'spætʃ] vt. 派遣；分派
 queue [kjuː] n. 队列；长队；辫子
 sync [sɪŋk] n. 同步，同时
 create [krɪ'et] vt. 创造，创作；造成
 concurrent [kən'kʌr(ə)nt] adj. 并发的；一致的；同时发生的
 thread [θrɛd] n. 线；螺纹；思路；衣服；线状物；玻璃纤维；路线
 serial ['sɪərɪəl] adj. 连续的；连载的；分期偿还的
 global ['ɡlobl] adj. 全球的；总体的；球形的
 priority [praɪ'ɔrəti] n. 优先；优先权；[数] 优先次序；优先考虑的事
 barrier ['bærɪə] n. 障碍物，屏障；界线 vt. 把…关入栅栏
 after ['ɑːftə] adv. 后来，以后
 apply [ə'plaɪ] vt. 申请；涂，敷；应用
 group  [gruːp] n. 组；团体
 leave [liːv] vt. 离开；留下；遗忘；委托
 semaphore ['seməfɔː] vi. 打旗语；发信号
 signal ['sɪgn(ə)l] n. 信号；暗号；导火线
 */

#import "ViewController.h"

@interface ViewController ()
{
    dispatch_semaphore_t semaphoreLock;
}

@property (nonatomic, assign) int ticketSurplusCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initTicketStatusNotSave];
    //在其它线程里执行 同步执行 + 主队列
//    [NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];
}

/*
 * 同步执行 + 并发队列
 * 同步执行不会开启新的线程，并发队列的任务都被当前线程按顺序执行
 */
- (void)syncConcurrent
{
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"syncConcurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@", [NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@", [NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@", [NSThread currentThread]);
        }
    });
    
    NSLog(@"syncConcurrent---end");
}

/*
 * 异步执行 + 并发队列
 * 异步执行会开启新线程,并发队列的每个任务都会开启一个新的线程无序执行
 */
- (void)asyncConcurrent
{
    NSLog(@"currentThread---%@", [NSThread currentThread]);
    NSLog(@"asyncConcurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@", [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@", [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@", [NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncConcurrent---end");
    
}

/*
 * 同步执行 + 串行队列
 * 同步执行不开启新线程，串行队列的任务使用当前线程按顺序执行
 */
- (void)syncSerial
{
    NSLog(@"CurrentThread---%@", [NSThread currentThread]);
    NSLog(@"syncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@", [NSThread currentThread]);
        }
    });
    
    NSLog(@"syncSerial---end");
}

/*
 * 异步执行 + 串行队列
 * 异步会开启新的线程，串行队列的任务使用新的线程按顺序执行
 */
- (void)asyncSerial
{
    NSLog(@"currentThread---%@", [NSThread currentThread]);
    NSLog(@"asyncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.aaa", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@", [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@", [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@", [NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncSerial---end");
}

/*
 * 同步执行 + 主队列
 * 特点(主线程调用)：互等卡主不执行
 * 特点(其它线程调用)：不会开启新线程，执行完一个任务，再执行下一个任务
 */

- (void)syncMain
{
    NSLog(@"currentThread---%@", [NSThread currentThread]);
    NSLog(@"syncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@", [NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@", [NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@", [NSThread currentThread]);
        }
    });
    
    NSLog(@"syncMain---end");
    
}

/*
 * 异步执行 + 主队列
 * 异步不会堵塞线程，主线程按顺序执行任务
 */
- (void)asyncMain
{
    NSLog(@"currentThread---%@", [NSThread currentThread]);
    NSLog(@"asyncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@", [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@", [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@", [NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncMain---end");
}

// GCD线程间的通信
- (void)communication
{
    //全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        //异步追加任务
        for (int i = 0; i < 3; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@", [NSThread currentThread]);
        }
        
        //回到主线程
        dispatch_async(mainQueue, ^{
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@", [NSThread currentThread]);
        });
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@", [NSThread currentThread]);
        }
    });
}

/*
 * 栅栏方法
 * 在执行完栅栏前面的操作之后，才执行栅栏操作，最后再执行栅栏后边的操作
 */
- (void)barrier
{
    dispatch_queue_t queue = dispatch_queue_create("com.tj.barrier", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@", [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@", [NSThread currentThread]);
        }
    });
    
    dispatch_barrier_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@", [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"4---%@", [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"5---%@", [NSThread currentThread]);
        }
    });
}

/*
 * 延时执行方法 dispatch_after
 */
- (void)after
{
    NSLog(@"currentThread---%@", [NSThread currentThread]);
    NSLog(@"asyncMain---begin");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"after---%@", [NSThread currentThread]);
    });
}

/*
 * 一次性代码(只执行一次)dispatch_once
 */
- (void)once
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"只执行一次的代码,默认是线程安全的");
    });
}

/*
 * 快速迭代方法 dispatch_apply
 */
- (void)apply
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@"apply---begin");
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"%zd---%@", index, [NSThread currentThread]);
    });
    NSLog(@"apply---end");
    
}

/*
 * GCD队列组：dispatch_group
 */
/*
 * 队列组：dispatch_group_notify
 * 当所有添加到group中的任务都执行完了，才会执行dispatch_group_notify里面的任务
 */
- (void)groupNotify
{
    NSLog(@"currentThread---%@", [NSThread currentThread]);
    NSLog(@"group---begin");
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@", [NSThread currentThread]);
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@", [NSThread currentThread]);
        }
        NSLog(@"group---end");
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@", [NSThread currentThread]);
        }
    });
}

/*
 * dispatch_group_wait
 * 等待上面的任务全部完成后，会往下继续执行(会阻塞当前线程)
 */
- (void)groupWait
{
    NSLog(@"currentThread---%@", [NSThread currentThread]);
    NSLog(@"group---begin");
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@", [NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@", [NSThread currentThread]);
        }
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"group---end");
}

/*
 * dispatch_group_enter
 * dispatch_group_leave
 * 当所有的任务执行完成之后，才执行dispatch_group_notify中的任务，这里的enter/leave组合等同于dispatch_group_async
 */

- (void)groupEnterAndLeave
{
    NSLog(@"currentThread---%@", [NSThread currentThread]);
    NSLog(@"group---begin");
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@", [NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@", [NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@", [NSThread currentThread]);
        }
        NSLog(@"group--end");
    });
}

/*
 * GCD信息量：dispatch_semaphore
 * 当计数器为0时，当前线程为等待状态，当计数器大于0时，当前线程继续执行
 * dispatch_semaphore_create：创建一个semaphore并初始化信号的总量
 * dispatch_semaphore_signal：发送一个信号，让信号总量+1
 * dispatch_semaphore_wait：让信号总量-1，当信号总量为0时就会一直等待(阻塞当前线程)，否则就可以正常执行
 */
- (void)semaphoreSync
{
    NSLog(@"currentThread---%@", [NSThread currentThread]);
    NSLog(@"semaphore---begin");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block int number = 0;
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"1---%@", [NSThread currentThread]);
        number = 100;
        dispatch_semaphore_signal(semaphore); // +1
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2----%@", [NSThread currentThread]);
        number = 200;
        dispatch_semaphore_signal(semaphore); // +1
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // -1
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // -1
    NSLog(@"semaphore---end, number = %d", number);
}

/*
 * Dispathc Semaphore 线程安全和线程同步(为线程加锁)
 * 线程安全：多线程执行的结果与单线程执行的结果一致，而且其它的变量的值也和预期一样，就是线程安全的
 * 线程同步：可以理解为线程A和线程B一块配合，A执行到一定程度时要依靠线程B的某个结果，于是停下来，示意B运行；B依言执行，再将结果给A；A再继续操作
 */
//模拟火车票售票
- (void)initTicketStatusNotSave
{
    NSLog(@"currentThread---%@", [NSThread currentThread]);
    NSLog(@"semaphore---begin");
    
    semaphoreLock = dispatch_semaphore_create(1);
    
    self.ticketSurplusCount = 50;
    
    //第一个售票窗口
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_SERIAL);
    
    //第二个售票窗口
    dispatch_queue_t queue2 = dispatch_queue_create("queue2", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(queue1, ^{
        [weakSelf saleTicketNotSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketNotSafe];
    });
}

- (void)saleTicketNotSafe
{
    while (1) {
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        if (self.ticketSurplusCount > 0) {
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%d 窗口：%@", self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        }else {
            NSLog(@"所有火车票已售完");
            dispatch_semaphore_signal(semaphoreLock);
            break;
        }
        dispatch_semaphore_signal(semaphoreLock);
    }
}

@end
