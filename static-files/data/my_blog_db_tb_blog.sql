INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (5, 'HelloWorld', '', 'http://localhost/admin/dist/img/rand/3.jpg', '### 1、hello
hello world

### 2、java
hello java', 24, '日常随笔', 'helloworld', 1, 20, 0, 1, '2019-10-12 15:34:30', '2019-10-12 15:34:30', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (6, '单例模式', '', 'http://www.wmding.com/admin/dist/img/rand/28.jpg', '### 1 单例模式
保证整个软件系统中，对某个类只能存在一个对象实例，且该类只提供一个取得其对象实例的方法（静态方法）

使用场景：需要频繁的进行创建和销毁的对象，创建对象时耗时过多或者耗费资源过多，但又经常使用到的对象、工具类对象、频繁访问数据库或者文件的对象（数据源、session工厂）


### 2 饿汉式（静态常量）

#### 2.1 代码示例
```java
public class Singleton {

    private static final Singleton singleton = new Singleton();

    private Singleton(){}

    public static Singleton getInstance(){
        return singleton;
    }
}
```

#### 2.2 优缺点

- 优点：写法简单，类装载的时候就完成了实例化，避免线程同步问题
- 缺点：在类装载的时候就完成了实例化，没有达到懒加载的效果，内存浪费
- 实际开发：可以使用，但是可能会造成内存浪费

----

### 3 饿汉式（静态代码块）

#### 3.1 代码示例
```java
public class Singleton {

    private static Singleton instance;

    static {
        instance = new Singleton();
    }

    private Singleton(){}

    public static Singleton getInstance(){
        return instance;
    }

}
```
#### 3.2 优缺点
- 和 2 基本一致，都是在类装载的时候，就实例化。但是这个对象的实例化是放在静态代码块中
- 实际开发：可以使用，但是可能会造成内存浪费s

---

### 4 懒汉式（线程不安全）

#### 4.1 代码示例

```java
public class Singleton {

    private static Singleton instance;

    private Singleton(){}

    public static Singleton getInstance(){
        if (instance == null){
            instance = new Singleton();
        }
        return instance;
    }

}
```

#### 4.2 总结
- 起到了懒加载的效果，但是只能在单线程中使用
- 如果在多线程下，一个线程进入if(instance == null)判断语句块，还未来得及往下执行，另一个线程也通过判断进入，就会产出多个实例
- 实际开发：不能使用

----

### 5 懒汉式（线程安全，同步方法）

#### 5.1 代码示例


```java
public class Singleton {

    private static Singleton instance;

    private Singleton(){}

    // 使用了synchronized来解决线程安全
    public static synchronized Singleton getInstance(){

        if (instance == null){
            instance = new Singleton();
        }
        return instance;
    }

}

```

#### 5.2 总结

- 解决了线程安全问题
- 效率太低下，每个线程在想获得类的实例时，getInstance()方法都要进行同步。但是其实这个方法只需要执行一次初始化就行了，后边获得该类实例，直接return就行了。
- 实际开发：不推荐使用

---
### 6 懒汉式（线程不安全，同步代码块）

#### 6.1 代码示例


```java
public class Singleton {

    private static Singleton instance;

    private Singleton(){}

    public static  Singleton getInstance(){

        if (instance == null){

            synchronized(Singleton.class){
                instance = new Singleton();
            }
        }
        return instance;
    }

}
```

#### 6.2 总结
- 这种方法的本意是对 5 进行改进，同步产生实例化的代码块
- 但是这中同步不能起到线程同步的作用，例如一个线程进入了判断，还没来得及往下执行，另一个线程也通过了这个判断语句，这样也就产生了多个实例
- 实际开发：不能使用

----

### 7 双重检查

#### 7.1 代码示例


```java
public class Singleton {

    private volatile static Singleton instance;

    private Singleton() {
    }

    public static Singleton getInstance() {

        if (instance == null) {

            synchronized (Singleton.class) {

                if (instance == null) {
                    instance = new Singleton();
                }
            }
        }
        return instance;
    }

}
```

#### 7.2 总结
- Double-Check ，判断了2次 if (instance == null)，来保证线程安全
- 线程安全，延迟加载，效率高
- 实际开发：推荐使用


### 8 静态内部类

#### 8.1 代码示例


```java
public class Singleton {


    private Singleton() {
    }

    // 写一个静态内部类，该类中有一个静态属性
    private static class SingletonInstance{
        private static final Singleton SINGLETON = new Singleton();
    }

    // 提供一个静态公有方法，直接返回SingletonInstance
    public static Singleton getInstance() {

        return SingletonInstance.SINGLETON;
    }

}
```

#### 8.2 总结

- 这种方式采用了类装载机制来保证初始化实例时只有一个线程
- 静态内部类在Singleton类被装载的时候并不会立即被实例化，而是在需要实例化时，调用 getInstance() 方法的时候才装载 SingletonInstance类，从而完成 Singleton 的实例化
- 避免了线程不安全，利用静态内部类来实现延迟加载，效率高
- 实际开发：推荐使用

-----

### 9 枚举

#### 9.1 代码示例

```java
public enum SingletonEnum {

    INSTANCE;

    public void sayHello(){
        System.out.println("hello");
    }

}


// 使用
public class Clent {
    public static void main(String[] args) {

        SingletonEnum singletonEnum = SingletonEnum.INSTANCE;
        singletonEnum.sayHello();

    }
}

```

#### 9.2 总结

- 借助枚举来实现单例模式，不仅能避免多线程同步问题，而且还能防止反序列化重新创建新的对象
- Effective Java 作者 Josh Bloah 提倡的方式
- 实际开发：推荐使用', 28, '设计模式', '设计模式,单例', 1, 2, 0, 1, '2019-10-30 03:32:45', '2019-10-30 03:32:45', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (7, '代理模式', '', 'http://www.wmding.com/admin/dist/img/rand/25.jpg', '### 1 代理模式

#### 1.1 基本介绍

- 代理模式：为一个对象提供一个替身，用来控制对这个对象的访问。即通过代理对象访问目标对象。这样可以在目标对象实现的基础上，增强额外的功能，扩展目标对象的功能。
- 代理模式有不同的形式，主要有三种 静态代理、动态代理（JDK代理或者叫接口代理）、Cglib代理（可以在内存中动态的创建对象，而不需要实现接口，也属于是动态代理）

### 2 静态代理

#### 2.1 静态代理基本说明

静态代理在使用时，需要定义接口或者父类，被代理对象（目标对象）和代理对象需要一起实现相同的接口或者是继承相同的父类。

#### 2.2 静态代理代码实现
定义一个接口
```Java
public interface ITeacherDao {
    void teach();
}
```

目标对象实现这个接口
```Java
public class TeacherDao implements ITeacherDao {
    @Override
    public void teach() {

        System.out.println(" teacher teach");
    }
}
```

使用静态代理方式,就需要在代理对象 TeacherDAOProxy 中也实现 ITeacherDAO
```Java
public class TeacherDaoProxy implements ITeacherDao{

    ITeacherDao target;

    public TeacherDaoProxy(ITeacherDao target) {
        this.target = target;
    }

    @Override
    public void teach() {
        System.out.println("开始代理-------");
        target.teach();
        System.out.println("提交代理-------");
    }
}
```
调用的时候通过调用代理对象的方法来调用目标对象.
```Java
public class Client {
    public static void main(String[] args) {
        // 创建目标对象（被代理对象）
        TeacherDao teacherDao = new TeacherDao();
        // 创建代理对象，同时将被代理对象传递给代理对象
        TeacherDaoProxy teacherDaoProxy = new TeacherDaoProxy(teacherDao);
        // 通过代理对象，调用到被代理对象的方法
        // 即:执行的是代理对象的方法，代理对象再去调用目标对象的方法
        teacherDaoProxy.teach();
    }
}
```

静态代理总结

- 优点：在不修改目标对象的功能前提下，能通过代理对象对目标对象的功能进行扩展
- 缺点：代理对象和目标对象需要实现同一个接口，会有很多代理类出现；一旦接口增加方法，目标对象和代理对象都需要修改

### 3 动态代理

#### 3.1 动态代理基本介绍
- 代理对象不需要实现接口，但是目标对象要实现接口，否则不能用动态代理
- 代理对象的生成，是利用 JDK 的 API，动态的在内存中构建代理对象
- 动态代理也叫做：JDK代理、接口代理

#### 3.2 JDK 中生成代理对象的 API

- 代理类所在的包：java.lang.reflect.Proxy
- 实现代理需要使用 Proxy.newProxyInstance 方法，这个方法接收 3 个参数：
>static Object newProxyInstance(ClassLoader loader, Class<?>[] interfaces,InvocationHandler h )


#### 3.3 代码实现

类图：


<img src="http://47.93.235.138:8000/upload/20191030_16084957.png" alt="Sample"  width="350" height="240">

接口：
```Java
public interface ITeacherDao {
    void teach();
}
```
被代理类：
```Java
public class TeacherDao implements ITeacherDao {
    @Override
    public void teach() {
        System.out.println("teacher teach");
    }
}
```
创建代理的类：
```Java
public class ProxyFactory {

    private Object target;

    public ProxyFactory(Object target) {
        this.target = target;
    }

    public Object getProxyInstance() {

        /**
         * //1. ClassLoader loader : 指定当前目标对象使用的类加载器, 获取加载器的方法固定
         * //2. Class<?>[] interfaces: 目标对象实现的接口类型，使用泛型方法确认类型
         * //3. InvocationHandler h : 事情处理，执行目标对象的方法时，会触发事情处理器方法, 会把当前执行的目标对象方法作为参数传入
         */
        Object instance = Proxy.newProxyInstance(target.getClass().getClassLoader(),
                target.getClass().getInterfaces(), (proxy, method, args) -> {
                    System.out.println("开始代理---------");

                    //反射机制调用目标对象的方法
                    Object invoke = method.invoke(target, args);

                    System.out.println("提交代理---------");
                    return invoke;
                });

        return instance;
    }
}
```

这样使用：
```Java
public class Client {
    public static void main(String[] args) {
    
        // 创建目标对象
        ITeacherDao teacherDao = new TeacherDao();
        
        ProxyFactory proxyFactory = new ProxyFactory(teacherDao);
        // 给目标对象，创建代理对象，可以转为 ITeacherDao
        ITeacherDao proxyInstance = (ITeacherDao) proxyFactory.getProxyInstance();
        // 内存中动态生成了代理对象
        System.out.println("proxyInstance: "+ proxyInstance.getClass().toString());
        // 通过代理对象，调用目标对象的方法
        proxyInstance.teach();
    }
}
```

### 4、Cglib代理

#### 4.1 Cglib 代理基本介绍

- 静态代理和 JDK 代理都要求目标对象实现一个接口，但是有时候目标对象只是一个单独的对象，并没有实现任何的接口，这个时候可以使用目标对象子类来实现代理，这就是 Cglib 代理。
- Cglib 代理也叫作子类代理，在内存中构建一个子类对象从而实现对目标对象功能扩展。
- Cglib 是一个强大的高性能的代码生成包,它可以在运行期扩展 java 类与实现 java 接口。它广泛的被许多 AOP 的 框架使用,例如 Spring AOP，实现方法拦截
- 在 AOP 编程中如何选择代理模式：目标对象需要实现接口，就使用 JDK 代理；如果目标对象不需要实现接口，就使用 Cglib 代理
- Cglib 包的底层是通过使用字节码处理框架 ASM 来转换字节码并生成新的类 

#### 4.2 代码实现

- 需要引入 jar



- 在内存中国动态构建子类，注意代理类不能为 final，否则报错 java.lang.IllegalArgumentException
- 目标对象的方法如果为final/static,那么就不会被拦截,即不会执行目标对象额外的业务方法.

类图：


被代理类（不需要实现接口）
```Java
public class TeacherDao {

    public void teach(){
        System.out.println(" Teacher teach");
    }
}
```

创建代理的类
```Java
public class ProxyFactory implements MethodInterceptor {

    private Object target;

    public ProxyFactory(Object target) {
        this.target = target;
    }

    public Object getProxyInstance() {
        // 创建一个工具类
        Enhancer enhancer = new Enhancer();
        // 设置父类
        enhancer.setSuperclass(target.getClass());
        // 设置回调函数
        enhancer.setCallback(this);
        // 创建子类对象，即代理对象
        return enhancer.create();
    }

    /**
     * 重写 intercept 方法，会调用目标对象的方法
     * @param o
     * @param method
     * @param objects
     * @param methodProxy
     * @return
     * @throws Throwable
     */
    @Override
    public Object intercept(Object o, Method method, Object[] objects, MethodProxy methodProxy) throws Throwable {

        System.out.println("Cglib 代理开始");
        Object invoke = method.invoke(target, objects);
        System.out.println("Cglib 代理提交");
        return invoke;
    }
}
```
这样使用：
```Java
public class Client {
    public static void main(String[] args) {

        // 创建目标对象
        TeacherDao teacherDao = new TeacherDao();

        // 获取到代理对象，并且将目标对象传递给代理对象
        TeacherDao proxyInstance = (TeacherDao) new ProxyFactory(teacherDao).getProxyInstance();

        // 执行代理对象的方法，触发 intercept 方法
        proxyInstance.teach();
    }
}
```', 28, '设计模式', '设计模式', 1, 56, 0, 0, '2019-10-30 03:40:02', '2019-10-30 03:40:02', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (8, 'Linux上的常用命令记录', '', 'http://www.wmding.com/admin/dist/img/rand/13.jpg', '### 1 Redis

查找redis-server的PID
>ps axu | grep redis
>lsof -i :8600

杀死该进程
>kill -9 PID

进入命令行
>./redis-cli

查看数据
>key *

刷新数据
>flushdb

### 2 Nginx

启动
>./nginx

关闭
> ./nginx -s stop

一个服务器上启动2个项目，然后使用2个域名指向这2个项目，修改配置文件
```
server {
    listen 80;
    server_name www.aaa.com; # www.aaa.com域名
    location / {
        proxy_pass http://localhost:8080; # 对应端口号8080
    }
}
server {
    listen 80;
    server_name www.bbb.com; # www.bbb.com域名
    location / {
        proxy_pass http://localhost:8081; # 对应端口号8081
    }
}
```

### 3 常用服务端操作命令

后台运行 jar
>nohup java -jar ./xxx-face.jar &

指定端口并运行 jar
>nohup java -jar -Dserver.port=80 my-blog-4.0.0-SNAPSHOT.jar &

查看进程
>ps -ef|grep xxx.jar

连接服务器
>ssh -p 10022 root@47.100.xxx.xxx

Mac 使用命令上传文件到服务器
> scp /Users/test/testFile test@www.linuxidc.com:/test/

### 4 压缩文件的操作命令

#### 4.1 打包并压缩文件
>tar -zcvf 打包压缩后的文件名 要打包压缩的文件

- z：调用gzip压缩命令进行压缩
- c：打包文件
- v：显示运行过程
- f：指定文件名

如果我们要打包test目录并指定压缩后的压缩包名称为test.tar.gz可以使用命令：`tar -zcvf test.tar.gz aaa.txt bbb.txt ccc.txt`或：`tar -zcvf test.tar.gz /test/`

#### 4.2 解压压缩包
>tar [-xvf] 压缩文件

- x：代表解压

1 将/test下的test.tar.gz解压到当前目录下可以使用命令：`tar -xvf test.tar.gz`

2 将/test下的test.tar.gz解压到根目录/usr下:`tar -xvf test.tar.gz -C /usr（- C代表指定解压的位置）`


### 5、Git 命令

commit后，想修改注释，可以使用该命令修改
> git commit --amend

### 6、常见目录说明

- **/bin：** 存放二进制可执行文件(ls、cat、mkdir等)，常用命令一般都在这里；
- **/etc：** 存放系统管理和配置文件；
- **/home：** 存放所有用户文件的根目录，是用户主目录的基点，比如用户user的主目录就是/home/user，可以用~user表示；
- **/usr ：** 用于存放系统应用程序；
- **/opt：** 额外安装的可选应用程序包所放置的位置。一般情况下，我们可以把tomcat等都安装到这里；
- **/proc：** 虚拟文件系统目录，是系统内存的映射。可直接访问这个目录来获取系统信息；
- **/root：** 超级用户（系统管理员）的主目录
- **/sbin:** 存放二进制可执行文件，只有root才能访问。这里存放的是系统管理员使用的系统级别的管理命令和程序。如ifconfig等；
- **/dev：** 用于存放设备文件；
- **/mnt：** 系统管理员安装临时文件系统的安装点，系统提供这个目录是让用户临时挂载其他的文件系统；
- **/boot：** 存放用于系统引导时使用的各种文件；
- **/lib ：** 存放着和系统运行相关的库文件 ；
- **/tmp：** 用于存放各种临时文件，是公用的临时文件存储点；
- **/var：** 用于存放运行时需要改变数据的文件，也是某些大文件的溢出区，比方说各种服务的日志文件（系统启动日志等。）等；
- **/lost+found：** 这个目录平时是空的，系统非正常关机而留下“无家可归”的文件（windows下叫什么.chk）就在这里。

### 7、常用命令记录

find 目录 参数：

在`/home`目录下查找以.txt结尾的文件名

>find /home -name "*.txt"
> 忽略大小写:
> find /home -iname "*.txt"

查看日志

> tail -f 文件 可以对某个文件进行动态监控，
> tail -f my.log


修改权限

> chmod u=rwx,g=rw,o=r aaa.txt
> // 递归给log目录下的所有文件授权
>
> chmod -R u=rwx,g=rwx,o=rwx ./log
> // 可以使用数字
> chmod 764 aaa.txt

查看当前redis 的运行情况

> ps aux|grep redis

如果直接用ps（（Process Status））命令，会显示所有进程的状态，通常结合grep命令查看某进程的状态。', 26, 'Linux', 'Linux', 1, 72, 0, 0, '2019-10-30 13:31:49', '2019-10-30 13:31:49', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (9, '单例模式', '', 'http://47.93.235.138:8000/upload/20191103_16300180.jpg', '### 1 单例模式
保证整个软件系统中，对某个类只能存在一个对象实例，且该类只提供一个取得其对象实例的方法（静态方法）

使用场景：需要频繁的进行创建和销毁的对象，创建对象时耗时过多或者耗费资源过多，但又经常使用到的对象、工具类对象、频繁访问数据库或者文件的对象（数据源、session工厂）

### 2、饿汉式（静态常量）

#### 2.1 代码示例
```java
public class Singleton {

    private static final Singleton singleton = new Singleton();

    private Singleton(){}

    public static Singleton getInstance(){
        return singleton;
    }
}
```

#### 2.2 优缺点

- 优点：写法简单，类装载的时候就完成了实例化，避免线程同步问题
- 缺点：在类装载的时候就完成了实例化，没有达到懒加载的效果，内存浪费
- 实际开发：可以使用，但是可能会造成内存浪费

----

### 3 饿汉式（静态代码块）

#### 3.1 代码示例
```java
public class Singleton {

    private static Singleton instance;

    static {
        instance = new Singleton();
    }

    private Singleton(){}

    public static Singleton getInstance(){
        return instance;
    }

}
```
#### 3.2 优缺点
- 和 2 基本一致，都是在类装载的时候，就实例化。但是这个对象的实例化是放在静态代码块中
- 实际开发：可以使用，但是可能会造成内存浪费s

---

### 4 懒汉式（线程不安全）

#### 4.1 代码示例

```java
public class Singleton {

    private static Singleton instance;

    private Singleton(){}

    public static Singleton getInstance(){
        if (instance == null){
            instance = new Singleton();
        }
        return instance;
    }

}
```

#### 4.2 总结
- 起到了懒加载的效果，但是只能在单线程中使用
- 如果在多线程下，一个线程进入if(instance == null)判断语句块，还未来得及往下执行，另一个线程也通过判断进入，就会产出多个实例
- 实际开发：不能使用

----

### 5 懒汉式（线程安全，同步方法）

#### 5.1 代码示例


```java
public class Singleton {

    private static Singleton instance;

    private Singleton(){}

    // 使用了synchronized来解决线程安全
    public static synchronized Singleton getInstance(){

        if (instance == null){
            instance = new Singleton();
        }
        return instance;
    }

}

```

#### 5.2 总结

- 解决了线程安全问题
- 效率太低下，每个线程在想获得类的实例时，getInstance()方法都要进行同步。但是其实这个方法只需要执行一次初始化就行了，后边获得该类实例，直接return就行了。
- 实际开发：不推荐使用

---
### 6 懒汉式（线程不安全，同步代码块）

#### 6.1 代码示例


```java
public class Singleton {

    private static Singleton instance;

    private Singleton(){}

    public static  Singleton getInstance(){

        if (instance == null){

            synchronized(Singleton.class){
                instance = new Singleton();
            }
        }
        return instance;
    }

}
```

#### 6.2 总结
- 这种方法的本意是对 5 进行改进，同步产生实例化的代码块
- 但是这中同步不能起到线程同步的作用，例如一个线程进入了判断，还没来得及往下执行，另一个线程也通过了这个判断语句，这样也就产生了多个实例
- 实际开发：不能使用

----

### 7 双重检查

#### 7.1 代码示例


```java
public class Singleton {

    private volatile static Singleton instance;

    private Singleton() {
    }

    public static Singleton getInstance() {

        if (instance == null) {

            synchronized (Singleton.class) {

                if (instance == null) {
                    instance = new Singleton();
                }
            }
        }
        return instance;
    }

}
```

#### 7.2 总结
- Double-Check ，判断了2次 if (instance == null)，来保证线程安全
- 线程安全，延迟加载，效率高
- 实际开发：推荐使用


### 8 静态内部类

#### 8.1 代码示例


```java
public class Singleton {


    private Singleton() {
    }

    // 写一个静态内部类，该类中有一个静态属性
    private static class SingletonInstance{
        private static final Singleton SINGLETON = new Singleton();
    }

    // 提供一个静态公有方法，直接返回SingletonInstance
    public static Singleton getInstance() {

        return SingletonInstance.SINGLETON;
    }

}
```

#### 8.2 总结

- 这种方式采用了类装载机制来保证初始化实例时只有一个线程
- 静态内部类在Singleton类被装载的时候并不会立即被实例化，而是在需要实例化时，调用 getInstance() 方法的时候才装载 SingletonInstance类，从而完成 Singleton 的实例化
- 避免了线程不安全，利用静态内部类来实现延迟加载，效率高
- 实际开发：推荐使用

-----

### 9 枚举

#### 9.1 代码示例

```java
public enum SingletonEnum {

    INSTANCE;

    public void sayHello(){
        System.out.println("hello");
    }

}


// 使用
public class Clent {
    public static void main(String[] args) {

        SingletonEnum singletonEnum = SingletonEnum.INSTANCE;
        singletonEnum.sayHello();

    }
}

```

#### 9.2 总结

- 借助枚举来实现单例模式，不仅能避免多线程同步问题，而且还能防止反序列化重新创建新的对象
- Effective Java 作者 Josh Bloah 提倡的方式
- 实际开发：推荐使用', 28, '设计模式', '单例,设计模式', 1, 24, 0, 0, '2019-11-03 08:30:05', '2019-11-03 08:30:05', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (10, '策略模式', '', 'http://www.wmding.com/admin/dist/img/rand/36.jpg', '### 传统实现

1、编写鸭子项目，根据不同的鸭子（野鸭，北京鸭，玩具鸭），定义鸭子的行为（叫，飞，游泳）

2、显示鸭子的信息


分析：一般会先定义一个父类的鸭子，然后在父类中定义鸭子的行为，然后让子类鸭子去继承。

定义父类
```Java
public abstract class Duck {

    public Duck() {

    }

    /**
     * 显示基本信息
     */
    public abstract void display();

    public void quack(){
        System.out.println("鸭子叫");
    }

    public void swim(){
        System.out.println("鸭子游泳");
    }

    public void fly(){
        System.out.println("鸭子飞翔");
    }
}
```

子类继承

野鸭
```Java
public class WildDuck extends Duck {

    @Override
    public void display() {
        System.out.println("这是野鸭");
    }
}
```

北京鸭，要求不会飞
```Java
public class BjDuck extends Duck {
    @Override
    public void display() {
        System.out.println("北京鸭");
    }

    // 重写改方法，根据自己的要求重写---》不会飞
    @Override
    public void fly() {
        System.out.println("北京鸭不能飞翔");
    }
}
```

玩具鸭（不会叫，不会游泳，不会飞）
```Java
public class ToyDuck extends Duck {
    @Override
    public void display() {
        System.out.println("玩具鸭");
    }
    
    @Override
    public void quack(){
        System.out.println("玩具鸭不能叫");
    }

    @Override
    public void swim(){
        System.out.println("玩具鸭不游泳");
    }

    @Override
    public void fly(){
        System.out.println("玩具鸭不飞翔");
    }
}
```

发现使用传统方法的话，父类虽然定义了一些共有的方法，但是在子类鸭上又不具备共性，导致子类需要重写父类的一些方法，需要寻找一个更加灵活的方法，将鸭子的这些行为进行组合。


### 使用策略模式实现

策略模式（Strategy Pattern），定义算法族（策略组），分别封装起来，让他们之间可以互相替换，此模式让算法的变化独立于使用算法的客户。

- 将变化的代码从不变的代码中分离出来
- 针对接口编程而不是具体的类
- 多使用组合、聚合，少使用继承

![](http://47.93.235.138:8000/upload/20191103_16333372.png)

定义策略接口
```Java
public interface FlyBehavior {
    void fly();
}
```

策略的具体实现
```Java
public class GoodFlyBehavior implements FlyBehavior {
    @Override
    public void fly() {
        System.out.println("好好飞翔");
    }
}
```

```Java
public class BadBehavior implements FlyBehavior {
    @Override
    public void fly() {
        System.out.println("飞的不好");
    }
}
```

```Java
public abstract class Duck {

    // 引入策略接口
    FlyBehavior flyBehavior;
    /**
     * 显示基本信息
     */
    public abstract void display();

    public void quack() {
        System.out.println("鸭子叫");
    }

    public void swim() {
        System.out.println("鸭子游泳");
    }

    public void fly() {
        if (flyBehavior != null) {
            flyBehavior.fly();
        }
    }
}
```

```Java
public class BeijingDuck extends Duck {

    public BeijingDuck() {
        flyBehavior = new GoodFlyBehavior();
    }

    @Override
    public void display() {
        System.out.println("北京鸭");
    }
}

```

```Java
public class WildDuck extends Duck {

    public WildDuck() {
        flyBehavior = new GoodFlyBehavior();
    }

    @Override
    public void display() {
        System.out.println("野鸭");
    }
}
```

客户端使用
```Java
public class Client {
    public static void main(String[] args) {
        WildDuck wildDuck = new WildDuck();
        wildDuck.fly();
    }
}
```


### 源码分析
#### Arrays 的 Comparator 中使用了策略模式

```Java
public class Strategy {
    public static void main(String[] args) {

        Integer[] data = {1, 4, 2, 5, 8, 3};
        
        Arrays.sort(data, new Comparator<Integer>() {
            @Override
            public int compare(Integer o1, Integer o2) {
                if (o1 > o2) {
                    return 1;
                } else {
                    return -1;
                }
            }
        });

        System.out.println(Arrays.toString(data));


        System.out.println("------------------------");


        TreeSet<Integer> integers = new TreeSet<>(new Comparator<Integer>() {
            @Override
            public int compare(Integer o1, Integer o2) {
                if (o1 > o2) {
                    return -1;
                } else {
                    return 1;
                }
            }
        });

        integers.add(3);
        integers.add(2);
        integers.add(5);

        for (Integer integer : integers) {
            System.out.println(integer);
        }
    }
}

```

Arrays.sort、TreeSet中都可以传入Comparator，即自定义排序规则。

### 总结

- 关键是：分析项目中的变化部分和不变部分
- 核心思想是：多用组合、聚合，少用继承；使用行为组合，而不是行为继承。
- 体现了“对修改关闭，对扩展开发”原则，客户端增加行为不用修改原有代码，只要添加一种策略（或行为）即可。
- 策略模式将算法封装在独立的 Strategy 类中使得你可以独立于其 Context 改变它，使它易于切换、易于理解、易于扩展
- 需要注意的是:每添加一个策略就要增加一个类，当策略过多是会导致类数目庞大', 24, '日常随笔', '策略,设计模式', 1, 28, 0, 0, '2019-11-03 08:35:11', '2019-11-03 08:35:11', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (11, '观察者模式', '', 'http://www.wmding.com/admin/dist/img/rand/26.jpg', '### 1 观察者模式
观察者模式（发布-订阅（Publish/Subscribe）模式，属于行为型模式的一种，它定义了一种一对多的依赖关系，让多个观察者对象同时监听某一个主题对象。这个主题对象在状态变化时，会通知所有的观察者对象，使他们能够自动更新自己。
### 2 代码实现

抽象观察者
```Java
public interface Observer {
    void update(String msg);
}
```
具体观察者
```Java
public class Person implements Observer{

    private String name;

    public Person(String name) {
        this.name = name;
    }

    @Override
    public void update(String msg) {
        System.out.println(name + "---" + msg);
    }
}
```
抽象被观察者
```Java
public interface Subject {

    /**
     * 添加监听
     *
     * @param observer
     */
    void addObserver(Observer observer);

    /**
     * 删除监听
     *
     * @param observer
     */
    void removeObserver(Observer observer);

    /**
     * 通知订阅者更新消息
     */
    void notification(String msg);

}
```
具体被观察者
```Java
public class TV implements Subject {

    // 存储订阅的用户
    List<Observer> list;

    public TV() {
        list = new ArrayList<>();
    }

    @Override
    public void addObserver(Observer observer) {

        list.add(observer);
    }

    @Override
    public void removeObserver(Observer observer) {
        if (list.contains(observer)) {
            list.remove(observer);
        }
    }

    @Override
    public void notification(String msg) {
        for (Observer observer : list) {
            observer.update(msg);
        }
    }
}
```
客户端调用
```Java
public class Client {
    public static void main(String[] args) {

        // 创建具体被观察者
        TV tv = new TV();

        // 创建具体观察者
        Person person = new Person("小明");

        // 订阅（用户查看电视）/或者理解为注册到被观察者的那个列表中
        tv.addObserver(person);

        // 电视发布天气预报
        tv.notification("今天下雨");
    }
}
```

### 3 总结
观察者模式，解除耦合，让耦合的双方都依赖于抽象，从而使得各自的变换都不会影响另一边的变换。

### 4 JDK自带的观察者模式

- Observable 的作用和地位等价于 Subject
- Obserable 是类，不是借口，类中已经实现了核心方法，即管理 Observer的方法

- Observer 的作用和地位等加于我们前面讲过的Observer，都有update 方法

JDK 源码

Observable
```Java
public class Observable {
    private boolean changed = false;
    private Vector<Observer> obs;

    public Observable() {
        obs = new Vector<>();
    }

    public synchronized void addObserver(Observer o) {
        if (o == null)
            throw new NullPointerException();
        if (!obs.contains(o)) {
            obs.addElement(o);
        }
    }

    public synchronized void deleteObserver(Observer o) {
        obs.removeElement(o);
    }

    public void notifyObservers() {
        notifyObservers(null);
    }

    public void notifyObservers(Object arg) {

        Object[] arrLocal;

        synchronized (this) {
            if (!changed)
                return;
            arrLocal = obs.toArray();
            clearChanged();
        }

        for (int i = arrLocal.length-1; i>=0; i--)
            ((Observer)arrLocal[i]).update(this, arg);
    }

    public synchronized void deleteObservers() {
        obs.removeAllElements();
    }

    protected synchronized void setChanged() {
        changed = true;
    }

    protected synchronized void clearChanged() {
        changed = false;
    }

    public synchronized boolean hasChanged() {
        return changed;
    }

    public synchronized int countObservers() {
        return obs.size();
    }
}

```
Observer
```Java
public interface Observer {
    void update(Observable o, Object arg);
}
```

客户端调用
```Java
public class Client {
    public static void main(String[] args) {

        ObserableImpl obserable = new ObserableImpl();

        obserable.addObserver(new Observer() {
            @Override
            public void update(Observable o, Object arg) {
                System.out.println("-----" + arg);
            }
        });

        obserable.setMsg("1111");

    }
}
```', 28, '设计模式', '观察者模式,设计模式', 1, 45, 0, 0, '2019-11-03 12:15:29', '2019-11-03 12:15:29', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (12, 'synchronized和Lock有什么区别', '', 'http://www.wmding.com/admin/dist/img/rand/22.jpg', '在实际的开发过程中我们更多的使用到了 synchronized 关键字来保证线程同步，当然也可以使用 Lock，所以需要了解下他们2个有什么区别。

### 1 他们的出生

synchronized 是 Java 中的关键字，属于是 JVM 层面。底层是 monitor 对象来完成，wait、notify 等方法也是依赖于 monitor 对象

![](http://47.93.235.138:8000/upload/20191103_21420072.png)

monitorenter、monitorexit


Lock 是具体的类（java.util.concurrent.locks.Lock），是 api 层的锁

### 2 使用方法
synchronized 不需要用户去手动释放锁，当 synchronized 代码执行完后，系统会自动让线程释放对锁的占用。

ReentrantLock 则需要用户去手动的去释放锁，如果没有主动释放锁，就有可能导致出现死锁的现象，即需要 lock()、unlock()方法配合 try/finally 语句来完成

### 3 等待释放可以中断
synchronized 不可中断，除非是异常或者是正常退出

ReentrantLock 可中断，实现方式有2中
- 设置超时方法 tryLock(long time, TimeUnit unit)
- lock.lockInterruptibly()放在代码块中，调用 thread.interrupt() 方法可中断

### 4 加锁是否公平
synchronized 是非公平锁

ReentrantLock 两者多可以，默认是公平锁。使用其构造方法进行设置 ReentrantLock(boolean fair)，ture -> 公平锁

### 5 锁绑定多个条件 Condition
synchronized 没有，要么随机唤醒一个，要么全部唤醒
ReentrantLock 用来实现分组唤醒需要唤醒的线程们，可以精确唤醒。', 27, 'Java', 'synchronized', 1, 44, 0, 0, '2019-11-03 13:26:48', '2019-11-03 13:26:48', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (13, 'Java基础', '', 'http://www.wmding.com/admin/dist/img/rand/40.jpg', '### 1 Java创建对象有几种方式？

#### 1.1 方式一
我们日常开发中最常用的一种方式，就是直接通过 new 关键字来创建对象
> User user = new User();

#### 1.2 方式二
通过反射来创建对象

```Java
// 使用 Class.newInstance。注意 forName中需要是全类名
Class<?> user1 = Class.forName("com.wmding.newObject.User");
User instance = (User) user1.newInstance();
instance.setAge(1);
System.out.println(instance.getAge());

// 使用  constructor.newInstance()
Class<?> user2 = Class.forName("com.wmding.newObject.User");
Constructor<?> constructor = user2.getConstructor();
User u = (User) constructor.newInstance();
u.setAge(111);
System.out.println(u.getAge());
```
Class 是在 java.lang 包下
Constructor 是在 java.lang.reflect 包下

#### 1.3 方式三
通过 clone 来创建对象
```Java
public class User implements Cloneable{
    private int age;
    private String name;

    public User() {
    }

    public User(int age, String name) {
        this.age = age;
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    // 提供创建对象的方法
    // 注意实现Cloneable方法后，clone 方法是 protected的，外边无法访问，所以类中提供了一个静态方法
    public static User getCloneUser(User user){
        try {
            return (User) user.clone();
        } catch (CloneNotSupportedException e) {
            e.printStackTrace();
        }
        return null;
    }
}

```
客户端使用
```Java
// 3、clone 创建对象
User cloneUser = User.getCloneUser(user);
System.out.println(cloneUser.getAge() + "--" + cloneUser.getName());
```

#### 1.4 方式四
```Java
// 使用 反序列化ObjectInputStream 的readObject()方法：类必须实现 Serializable接口
// 序列化
String FILE_NAME = "user.obj";
try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(FILE_NAME))) {
    oos.writeObject(user);
}
// 反序列化
try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(FILE_NAME))) {
    User user4 = (User) ois.readObject();
    System.out.println("反序列化：" + user4.getName());
}
```
如何避免对象被序列化，可是使用关键字 transient 。



### 2 Java中String、StringBuffer、StringBuilder的区别

#### 2.1 可变性，通过查看源码，String 类中使用字符数据来保存字符串
```
private final char value[];

public String() {
	this.value = "".value;
}
```
所以 String 对象时不可变的；
StringBuilder 和 StringBuffer 这两个类都继承 AbstractStringBuilder 类，在 AbstractBuilder 中也是使用字符数组来保存字符串，但是没有 final ，所以是可变的
```
char[] value;
```
#### 2.2 线程安全性

AbstractStringBuilder 是 StringBuilder 和 StringBuffer 的公共父类，定义了字符串的基本操作，如 append、insert、indexOf 等。
同时 StringBuffer 对方法加了同步锁(synchronized)，或者对调用的方法加入了同步锁，所以是线程安全的；
```Java
@Override
public synchronized StringBuffer append(String str) {
    toStringCache = null;
    super.append(str);
    return this;
}
```
StringBuilder 并没有加入同步锁，所以是非线程安全的。

#### 2.3 性能

每次对 String 类型进行改变的时候，都会生成一个新的 String 对象，然后将引用指向新的 String 对象；StringBuffer 每次都会对自身对象进行操作，而不是生成一个新的对象；StringBuilder 相对于 StringBuffer 性能会有 10% ~ 15% 的提升，但是 StringBuilder 却是线程不安全的。


### 3 String为什么是不可变的？有什么好处？

```Java
public final class String
    implements java.io.Serializable, Comparable<String>, CharSequence {
    /** The value is used for character storage. */
    private final char value[];
	...
	}
```
- String 类是使用 final 来修饰的，说明String不能被继承
- String 的成员字段 value 是个 char[] 数组，而且是用 final 修饰的，即 value 的这个引用地址不可变，但是数组地址是可变的。为了防止它被修改，使用了 private 来进行修饰，外部不可访问修改。

String 不可变的好处：
- 多线程下安全性
- 类加载中体现的安全性：类加载器要用到字符串，不可变提供了安全性，以便正确的类被加载
- 使用常量池可以节省空间：在大量使用字符串的情况下，可以节省内存空间，提高效率。但之所以能实现这个特性，String的不可变性是最基本的一个必要条件

### 4 为什么重写equals时必须重写hashCode方法

在[Java中equals()的若干问题解答](http://www.wmding.com/blog/14 "Java中equals()的若干问题解答")中进行解答。

### 5 java代码执行顺序

```Java
class HelloA {

    public HelloA() {
        System.out.println("HelloA");
    }

    { System.out.println("I''m A class"); }

    static { System.out.println("static A"); }

}

public class HelloB extends HelloA {
    public HelloB() {
        System.out.println("HelloB");
    }

    { System.out.println("I''m B class"); }

    static { System.out.println("static B"); }

    public static void main(String[] args) {
　　　　 new HelloB();
　　 }
}
```

运行结果：
```Java
static A
static B
I''m A class
HelloA
I''m B class
HelloB
```
- 类加载之后，按从上到下（从父类到子类）执行被static修饰的语句
- 当static语句执行完之后,再执行main方法
- 如果有语句new了自身的对象，将从上到下执行构造代码块、构造器（两者可以说绑定在一起）


升级版本的代码执行顺序实例代码：
```Java
class X {

    Y b = new Y();

    X() {
        System.out.print("X");
    }
}

class Y {

    Y() {
        System.out.print("Y");
    }
}

public class Z extends X {

    Y y = new Y();

    Z() {

        System.out.print("Z");
    }
    public static void main(String[] args) {
        new Z();

    }

}
```

运行结果：
```
YXYZ
```

### 6 Java中的final关键字，从它修改类、方法、变量方面理解

- 可以用来修饰类，修饰的类无法被继承，例如String类、Math类、Integer类等；
- 可以用来修饰方法，修饰的方法无法被重写；
- 可以用来修饰变量，修饰对象是说该对象的内存地址不可改变，但是内存地址指向的内容是可以改变的', 27, 'Java', 'Java', 1, 76, 0, 0, '2019-11-05 04:57:36', '2019-11-05 04:57:36', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (14, 'Java中equals()的若干问题解答', '', 'http://www.wmding.com/admin/dist/img/rand/8.jpg', 'Java 关于 equals 的一些问题是基础的重点，本贴就这个问题进行记录
### 1 == 和 equals 的区别

#### 1.1 == 到底是比较什么

它的作用是判断两个对象的地址是否相等
- 基本数据类型比较的是值
- 引用数据类型比较的是内存地址

#### 1.2 equals() 比较的又是什么
equals() 定义在JDK的Object.java中。通过判断两个对象的地址是否相等(即，是否是同一个对象)来区分它们是否相等

- 类没有重写 equals 方法，比较的是内存地址是否一致
- 重写了 equals 方法，在实际开发中，我们重写 equals() 方法来比较两个对象的内容是否相等；若它们的内容相等，则返回 true (即，认为这两个对象相等)。

```Java
public static void main(String[] args) {
    String a = new String("ab"); // a为一个引用
    String b = new String("ab"); // b为另一个引用,对象的内容一样
    String a1 = "ab"; // 放在常量池中
    String b1 = "ab"; // 从常量池中查找
    if (a1 == b1) // true
        System.out.println("a1==b1");
    if (a == b) // false，非同一对象
        System.out.println("a==b");
    if (a.equals(b)) // true
        System.out.println("a equals b");
    if (11 == 11.0) { // true
        System.out.println("true");
    }
}
```

### 2 为什么重写equals时必须重写hashCode方法

#### 2.1 样例代码

创建2个对象，对象中的属性值都是一样的，但是 equals 返回 false，然后这2个对象我们要放到 HashMap 中，但是会出现2个一样的数据占用了2个位置，为了让 HashMap 只保存一个，这个时候，就需要重写 equals 方法。

如下代码，重写了 equals 方法
```java
public class Person1 {
    private String name;

    public Person1(String name) {
        this.name = name;
    }

    public Person1() {
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Person1 person1 = (Person1) o;
        return Objects.equals(name, person1.name);
    }
}

```

客户端调用
```java
public class Test {
    public static void main(String[] args) {

        final Person1 person1 = new Person1("1");
        final Person1 person2 = new Person1("1");

        System.out.println("person1 == person2: " + person1.equals(person2));
        System.out.println("person1: " + person1.hashCode());
        System.out.println("person2: " + person2.hashCode());

        final HashMap<Object, Object> objectObjectHashMap = new HashMap<>();

        objectObjectHashMap.put(person1,"11");
        objectObjectHashMap.put(person2,"11");

        System.out.println(objectObjectHashMap.size());
    }
}

```

这个运行结果发现在 HashMap中还是有2条，这个是因为这2个对象的hashCode是不一样的。

#### 2.2 为什么重写equals方法时必须重写 hashCode 方法

hashCode() 的作用是获取哈希码，也称为散列码；它实际上是返回一个int整数。这个哈希码的作用是确定该对象在哈希表中的索引位置。

>它返回的就是根据对象的内存地址换算出的一个值。这样一来，当集合要添加新的元素时，先调用这个元素的hashCode方法，就一下子能定位到它应该放置的物理位置上。如果这个位置上没有元素，它就可以直接存储在这个位置上，不用再进行任何比较了；如果这个位置上已经有元素了，就调用它的equals方法与新元素进行比较，相同的话就不存了，不相同就散列其它的地址。这样一来实际调用equals方法的次数就大大降低了，几乎只需要一两次。

因为上边2个对象都是重新 new 出来的，所以导致他们的地址是不一样的。假如 hashCode是不一样的，HashMap 区别对象的唯一标准是，两个对象的 hashCode是否一致，再判断equals。所以需要重写。

例如：
```java
@Override
public int hashCode() {
    return Objects.hash(name);
}
```', 27, 'Java', 'Java基础,equals', 1, 75, 0, 0, '2019-11-05 13:05:14', '2019-11-05 13:05:14', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (15, 'Spring支持的常用数据库传播属性和事务隔离级别', '', 'http://www.wmding.com/admin/dist/img/rand/31.jpg', '### 1 事务的特性（ACID）
- 原子性（Atomicity）
- 一致性（Consistency）
- 隔离性（Isolation）
- 持久性（Durubility）

### 2 事务的传播属性

使用 @Transaction(propagation=) 来设置事务的传播行为。通常是由设置此属性来设置一个方法运行在一个开启了事务的方法中时，当前方法是使用原来的事务，还是开启一个新的事务。

一般使用这 2 种：
- Propagation.REQUIRED：默认值，使用原来是的事务
- Propagation.REQUIREDS_NEW：将原来的事务挂起，新开启一个事务。

### 3 事务的隔离级别

 ioslation：用来设置事务的隔离级别
- Isolation.REPEATABLE_READ  可重复读（MySQL默认事务隔离级别）
例如，第一次读取A 为 20，但是此时其他线程对 A 进行了修改，然后第二次该线程再次读取时，还为 20。
- Isolation.READ_COMMITTED 读已提交（Oracle默认事务隔离级别，开发时通常使用的隔离级别）', 27, 'Java', '事务', 1, 37, 0, 0, '2019-11-10 14:27:20', '2019-11-10 14:27:20', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (16, 'Java多线程', '', 'http://www.wmding.com/admin/dist/img/rand/15.jpg', '### 1 线程有哪些基本状态
```Java
public enum State {
        /**
         * Thread state for a thread which has not yet started.
         */
        NEW,

        /**
         * Thread state for a runnable thread.  A thread in the runnable
         * state is executing in the Java virtual machine but it may
         * be waiting for other resources from the operating system
         * such as processor.
         */
        RUNNABLE,

        /**
         * Thread state for a thread blocked waiting for a monitor lock.
         * A thread in the blocked state is waiting for a monitor lock
         * to enter a synchronized block/method or
         * reenter a synchronized block/method after calling
         * {@link Object#wait() Object.wait}.
         */
        BLOCKED,

        /**
         * Thread state for a waiting thread.
         * A thread is in the waiting state due to calling one of the
         * following methods:
         * <ul>
         *   <li>{@link Object#wait() Object.wait} with no timeout</li>
         *   <li>{@link #join() Thread.join} with no timeout</li>
         *   <li>{@link LockSupport#park() LockSupport.park}</li>
         * </ul>
         *
         * <p>A thread in the waiting state is waiting for another thread to
         * perform a particular action.
         *
         * For example, a thread that has called <tt>Object.wait()</tt>
         * on an object is waiting for another thread to call
         * <tt>Object.notify()</tt> or <tt>Object.notifyAll()</tt> on
         * that object. A thread that has called <tt>Thread.join()</tt>
         * is waiting for a specified thread to terminate.
         */
        WAITING,

        /**
         * Thread state for a waiting thread with a specified waiting time.
         * A thread is in the timed waiting state due to calling one of
         * the following methods with a specified positive waiting time:
         * <ul>
         *   <li>{@link #sleep Thread.sleep}</li>
         *   <li>{@link Object#wait(long) Object.wait} with timeout</li>
         *   <li>{@link #join(long) Thread.join} with timeout</li>
         *   <li>{@link LockSupport#parkNanos LockSupport.parkNanos}</li>
         *   <li>{@link LockSupport#parkUntil LockSupport.parkUntil}</li>
         * </ul>
         */
        TIMED_WAITING,

        /**
         * Thread state for a terminated thread.
         * The thread has completed execution.
         */
        TERMINATED;
    }
```

### 使用 Executors 创建线程池

```Java
public class NewFixedThreadPoolDemo {

    public static void main(String[] args) {

//        ExecutorService threadPool = Executors.newFixedThreadPool(5);
//        ExecutorService threadPool = Executors.newSingleThreadExecutor();
        ExecutorService threadPool = Executors.newCachedThreadPool();


        HashMap<Object, Object> hashMap = new HashMap<>();

        User user = new User();

        hashMap.put(user,"111");

        user = new User();

        Object o = hashMap.get(user);
        System.out.println(o);

        try {
            for (int i = 0; i < 10; i++) {
                threadPool.execute(() -> {
                    System.out.println(Thread.currentThread().getName() + "执行");
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            threadPool.shutdown();
        }

    }
}
```

但是在 阿里Java开发手册中明确指出不能使用这种方式进行创建

![](http://47.93.235.138:8000/upload/20191123_15322986.png)


### 3 自定义创建线程池

```Java
public ThreadPoolExecutor(int corePoolSize,
                          int maximumPoolSize,
                          long keepAliveTime,
                          TimeUnit unit,
                          BlockingQueue<Runnable> workQueue,
                          ThreadFactory threadFactory,
                          RejectedExecutionHandler handler) {
    if (corePoolSize < 0 ||
        maximumPoolSize <= 0 ||
        maximumPoolSize < corePoolSize ||
        keepAliveTime < 0)
        throw new IllegalArgumentException();
    if (workQueue == null || threadFactory == null || handler == null)
        throw new NullPointerException();
    this.acc = System.getSecurityManager() == null ?
            null :
            AccessController.getContext();
    this.corePoolSize = corePoolSize;
    this.maximumPoolSize = maximumPoolSize;
    this.workQueue = workQueue;
    this.keepAliveTime = unit.toNanos(keepAliveTime);
    this.threadFactory = threadFactory;
    this.handler = handler;
}
```
各个参数说明

- corePoolSize:线程池中的常驻核心线程数
- maximumPoolSize:线程池中能够容纳同时执行的最大线程数，此值必须大于等于1
- keepAliveTime:多余的空闲线程的存活时间
当前池中线程数量超过corePoolSize时，当空闲时间达到keepAliveTime时，多余线程会被销毁，直到只剩下corePoolSize个线程为止
- unit：keepAliveTime的单位
- workQueue：任务队列，被提交但尚未被执行的任务
- threadFactory：表示生成线程池中工作线程的线程工厂，用于创建线程，一般默认的即可
- Handler：拒绝策略，表示当队列满了，并且工作线程大于线程池的最大线程数时如何来拒绝请求执行的runnable的策略

示例：
```Java
public class NewThreadPoolDemo {
    public static void main(String[] args) {
        ThreadPoolExecutor threadPool = new ThreadPoolExecutor(
                2,
                5,
                2L,
                TimeUnit.SECONDS,
                new LinkedBlockingQueue<>(3),
                Executors.defaultThreadFactory(),
                new ThreadPoolExecutor.AbortPolicy()
        );


        try {
            for (int i = 0; i < 10; i++) {
                threadPool.execute(new Runnable() {
                    @Override
                    public void run() {

                        System.out.println(Thread.currentThread().getName() + "执行");
                    }
                });
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            threadPool.shutdown();
        }
    }
}
```

### 4 线程池底层工作原理
1、在创建了线程池后，开始等待请求

2、当调用execute方法添加一个请求任务时，线程池会作出如下的判断
- 如果正在运行的线程数量小于 corePoolSize ，那么马上创建线程运行这个任务
- 如果正在运行的线程数量大于或者等于 corePoolSize ，那么就将这个任务放入队列
- 如果这个时候队列满了且正在运行的线程数量还小于 maximumPoolSize ，那么还是要创建非核心线程立刻运行这个任务
- 如果队列满了且正在运行的线程数量大于或等于 maximumPoolSize，那么线程池会启动饱和拒绝策略来执行

3、当一个线程完成任务时，它会从队列中取下一个任务来执行

4、当一个线程无事可做超过一定的时间（keepAliveTime）时，线程会判断：
- 如果当前运行的线程数量大于 corePoolSize，那么这个线程就被停掉，所以线程池的所有任务后，它最终会收缩到 corePoolSize 的大小


### 5 拒绝策略
- AbortPolicy（默认）直接抛出 java.util.concurrent.RejectedExecutionException 异常
- CallerRunsPolicy 调用者运行 ，该策略既不会抛弃任务，也不会抛出异常，而是将某些任务回退到调用者，从而降低新任务的流量
- DiscardOldestPolicy 抛弃队列中等待最久的任务，然后把当前任务加入到队列中尝试再次提交当前任务
- DiscardPolicy 该策略默默的丢弃无法处理的任务，不予任何处理也不抛出异常，如果允许任务丢失，这是最好的一种策略', 27, 'Java', '多线程', 1, 112, 0, 0, '2019-11-11 01:50:49', '2019-11-11 01:50:49', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (17, 'Java集合', '', 'http://www.wmding.com/admin/dist/img/rand/36.jpg', '本帖来系统记录Java的集合

### 1、说说List,Set,Map三者的区别？

List 进行顺序存储
Set 不允许重复
Map 进行 key-value 的存储

### 2、Arraylist 与 LinkedList 区别?

#### 2.1、是否线程安全

#### 2.2、底层数据结构

#### 2.3、插入和删除

#### 2.4、随机访问（取元素）

#### 2.5、内存占用


- 补充内容:RandomAccess接口



- 补充内容:双向链表和双向循环链表
- ArrayList 与 Vector 区别呢?为什么要用Arraylist取代Vector呢？
- 说一说 ArrayList 的扩容机制吧
- HashMap 和 Hashtable 的区别
- HashMap 和 HashSet区别
- HashSet如何检查重复
- HashMap的底层实现
- JDK1.8之前
- JDK1.8之后
- HashMap 的长度为什么是2的幂次方
- HashMap 多线程操作导致死循环问题
- ConcurrentHashMap 和 Hashtable 的区别
- ConcurrentHashMap线程安全的具体实现方式/底层具体实现
- JDK1.7（上面有示意图）
- JDK1.8 （上面有示意图）
- comparable 和 Comparator的区别
- Comparator定制排序
- 重写compareTo方法实现按年龄来排序
- 集合框架底层数据结构总结
- Collection：1. List、2. Set
- Map
- 如何选用集合?


-------
HashMap 的底层实现

ArrayList 的底层实现

[ArrayList源码分析](https://github.com/Snailclimb/JavaGuide/blob/master/docs/java/collection/ArrayList-Grow.md "ArrayList源码分析")

ConcurrentHashMap 的底层实现', 27, 'Java', 'Java', 0, 6, 0, 0, '2019-11-11 05:58:41', '2019-11-11 05:58:41', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (18, 'JUC学习记录', '', 'http://www.wmding.com/admin/dist/img/rand/14.jpg', '### 1 JUC 是什么
JUC 是 java.util.concurrent 的缩写，在此包中增加了在并发编程中很常用的工具类,
用于定义类似于线程的自定义子系统,包括线程池,异步 IO 和轻量级任务框架;还提供了设计用于多线程上下文中的 Collection 实现等
### 2 Lock 接口
学习参考这篇文章，讲的很清楚
[Java并发编程：Lock](https://www.cnblogs.com/dolphin0520/p/3923167.html "Java并发编程：Lock")

经典卖票的题目，3个窗口卖30张票
- 线程 操作 资源类
- 为了解决并发问题，一般会使用 synchronized 或者 Lock

```Java
class Ticket {

    private int number = 30;
    private Lock lock = new ReentrantLock();

//    public synchronized void sell() {
//        if (number > 0) {
//            System.out.println(Thread.currentThread().getName() + "\\t还剩: " + number);
//            number--;
//        }
//    }

    public void sell() {
        lock.lock();
        try {
            if (number > 0) {
                System.out.println(Thread.currentThread().getName() + "\\t还剩: " + number);
                number--;
            }
        } finally {
            lock.unlock();
        }
    }
}


public class TicketDemo {

    public static void main(String[] args) {

        Ticket ticket = new Ticket();

        // 创建一个线程
        new Thread(() -> {
            for (int i = 0; i < 30; i++) {
                ticket.sell();
            }
        }, "线程A").start();

        new Thread(() -> {
            for (int i = 0; i < 30; i++) {
                ticket.sell();
            }
        }, "线程B").start();

        new Thread(() -> {
            for (int i = 0; i < 30; i++) {
                ticket.sell();
            }
        }, "线程C").start();

    }
}
```

### 3 Java 8 之 lambda 表达式
- 1、拷贝小括号，写死右括号，落地大括号
- 2、@FunctionalInterface
Java 8为函数式接口引入了一个新注解@FunctionalInterface，
主要用于编译级错误检查，加上该注解，当你写的接口不符合函数式接口定义的时候，编译器会报错。
- 3、java 8之前，接口中不允许有实现，之后，可以使用default进行默认的实现
- 4、静态方法实现

```Java
package com.wmding.lambda;

@FunctionalInterface
interface Src {

    int add(int a, int b);

    default void get(int x) {
        System.out.println("get--->" + x);
    }

    static void staticMethod() {
        System.out.println("staticMethod");
    }

}

public class Client {
    public static void main(String[] args) {
        // 不使用lambda表达式
        Src src = new Src() {
            @Override
            public int add(int a, int b) {
                return a + b;
            }
        };
        System.out.println(src.add(1, 1));

        // 使用lambda表达式
        Src src2 = (a, b) -> a + b;
        System.out.println(src2.add(1, 2));

        // 调用接口中的静态方法
        Src.staticMethod();
    }
}
```

### 4 线程间通信


生产者消费者示例
实现：2个线程，操作一个初始值为 0 的变量，2个线程对变量加一，2个线程对变量减一，交替10次，最后变量的值还为0，

```Java
public synchronized void add() throws InterruptedException {
        // 判断，是否等于0，如果是等于0，就加一；如果不是等于0，就等待
        if (num != 0) {
            this.wait();
        }
        num++;

        System.out.println(Thread.currentThread().getName() + ": " + num);

        // 通知
        this.notifyAll();
    }
```

如果这里使用if时，会出现线程的虚假唤醒，也就是当 num 为1时，这个时候线程阻塞了，然后唤醒后，继续往下走，会将 num 变为2，不在符合 1-》0，1-》0的交替了。

需要注意：
- 多线程交互中，必须防止多线程的虚假唤醒，即（判断只能是while，不能是if）

```Java
/**
 * 创建资源类
 */
class Src {

    private int num = 0;

    public synchronized void add() throws InterruptedException {

        // 判断，是否等于0，如果是等于0，就加一；如果不是等于0，就等待
        while (num != 0) {
            this.wait();
        }
        num++;

        System.out.println(Thread.currentThread().getName() + ": " + num);

        // 通知
        this.notifyAll();
    }

    public synchronized void sub() throws InterruptedException {
        while (num == 0) {
            this.wait();
        }
        num--;
        System.out.println(Thread.currentThread().getName() + ": " + num);

        // 通知
        this.notifyAll();
    }
}

public class ThreadWaitNotifyDemo {
    public static void main(String[] args) {

        Src src = new Src();

        new Thread(() -> {

            for (int i = 0; i < 10; i++) {

                try {
                    src.add();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }

        }, "线程A").start();

        new Thread(() -> {

            for (int i = 0; i < 10; i++) {

                try {
                    src.sub();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }, "线程B").start();

        new Thread(() -> {

            for (int i = 0; i < 10; i++) {

                try {
                    src.add();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }

        }, "线程C").start();

        new Thread(() -> {

            for (int i = 0; i < 10; i++) {

                try {
                    src.sub();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }, "线程D").start();
    }
}
```


### 5 线程间定制化调用通信
实现精准通知顺序访问
要求：
1、多线程间的顺序调用，实现A->B->C
三个线程启动，A打印5次，B打印10次，C打印15次。循环10轮

```Java
class Src {

    /**
     * 定义一个标识位，用来区分该哪个线程执行
     */
    private int flog = 1;

    private Lock lock = new ReentrantLock();
    Condition condition1 = lock.newCondition();
    Condition condition2 = lock.newCondition();
    Condition condition3 = lock.newCondition();

    /**
     * 打印5次
     *
     * @throws InterruptedException
     */
    public void sout5() throws InterruptedException {

        lock.lock();

        try {

            // 如果不是自己的标识，就等待，是的话就继续往下走
            while (flog != 1) {
                condition1.await();
            }

            for (int i = 1; i <= 5; i++) {
                System.out.println(Thread.currentThread().getName() + "-->" + i);
            }

            // 修改标识
            flog = 2;

            // 唤醒通知下一个
            condition2.signal();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            lock.unlock();
        }

    }

    /**
     * 打印10次
     *
     * @throws InterruptedException
     */
    public void sout10() throws InterruptedException {

        lock.lock();

        try {

            while (flog != 2) {
                condition2.await();
            }

            for (int i = 1; i <= 10; i++) {
                System.out.println(Thread.currentThread().getName() + "-->" + i);
            }

            flog = 3;

            condition3.signal();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            lock.unlock();
        }

    }

    /**
     * 打印15次
     *
     * @throws InterruptedException
     */
    public void sout15() throws InterruptedException {

        lock.lock();

        try {

            while (flog != 3) {
                condition3.await();
            }

            for (int i = 1; i <= 15; i++) {
                System.out.println(Thread.currentThread().getName() + "-->" + i);
            }

            flog = 1;

            condition1.signal();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            lock.unlock();
        }

    }


}

public class ThreadOrderAccess {
    public static void main(String[] args) {

        Src src = new Src();
        // 创建一个线程
        new Thread(() -> {
            try {

                for (int i = 0; i < 10; i++) {
                    src.sout5();
                }

            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }, "A").start();

        new Thread(() -> {
            try {
                for (int i = 0; i < 10; i++) {
                    src.sout10();
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }, "B").start();


        new Thread(() -> {
            try {
                for (int i = 0; i < 10; i++) {
                    src.sout15();
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }, "C").start();
    }
}
```

### 6 NotSafeDemo

常用的 ArrayList、HashSet、HashMap 等在多线程操作下，会出现异常
> java.util.ConcurrentModificationException 并发修改异常

并发争抢修改导致了该异常，一个线程正在写入，一个线程过来争抢资源，导致数据不一致异常。

如何解决呢？
- 使用 Vector
- 使用Collections.synchronizedList(new ArrayList<>());
- 使用CopyOnWriteArrayList
```Java
    /**
     * Appends the specified element to the end of this list.
     *
     * @param e element to be appended to this list
     * @return {@code true} (as specified by {@link Collection#add})
     */
    public boolean add(E e) {
        final ReentrantLock lock = this.lock;
        lock.lock();
        try {
            Object[] elements = getArray();
            int len = elements.length;
            Object[] newElements = Arrays.copyOf(elements, len + 1);
            newElements[len] = e;
            setArray(newElements);
            return true;
        } finally {
            lock.unlock();
        }
    }
```

> 写时复制：CopyOnWrite容器即写时复制容器。往一个容器添加元素的时候，不直接往当前容器object[]添加，而是先将当前容器Object[]进行copy，复制出一个新的容器Object[] newElements，然后往新的容器Object newElements里添加元素，添加完元素之后，再将原容器的引用指向新的容器setArray(newElements)。这样做的好处是可以对CopyOnWrite容器进行并发的读，而不需要加锁，因为当前容器不会添加任何元素，所以CopyOnWrite容器也是一种读写分离的思想，读和写不同的容器。

Set
```Java
Collections.synchronizedSet(new HashSet<String>());
Set<String> set = new CopyOnWriteArraySet();
//HashSet 底层 HashMap
//CopyOnWriteArraySet 底层 CopyOnWriteArrayList
```
Map
```Java
Collections.synchronizedMap(new HashMap<String>());
Map<String, String> map = new ConcurrentHashMap<>();
```

### 7 Callable接口

 Callable和Runnable有以下几点不同：
* (1)、Callable规定的方法是call()，而Runnable规定的方法是run().
* (2)、Callable的任务执行后可返回值，而Runnable的任务是不能返回值的.
* (3)、call()方法可抛出异常，而run()方法是不能抛出异常的.
* (4)、运行Callable任务可拿到一个Future对象,获取线程的执行结果.

Callable  的使用如下
```Java
class MyThread implements Callable<String>{

    @Override
    public String call() throws Exception {
        return "hello";
    }
}
public class CallableDemo {
    public static void main(String[] args) throws ExecutionException, InterruptedException {
        FutureTask<String> stringFutureTask = new FutureTask<>(new MyThread());

        // 创建一个线程
        new Thread(stringFutureTask, "A").start();
        String s = stringFutureTask.get();
        System.out.println("--->" + s);
    }
}
```
### 8 JUC 强大的辅助类

#### 8.1 CountDownLatch

CountDownLatch 主要有两个方法
- 当一个或者多个线程调用 await 方法时，这些线程会阻塞。其他线程调用 countDown 方法会将计数器减一（调用countDown方法的线程不会阻塞）
- 当计数器的值变为0时，因 await 方法阻塞的线程会被唤醒，继续执行。

```Java
public class CountDownLatchDemo {

    public static void main(String[] args) {

        CountDownLatch countDownLatch = new CountDownLatch(10);

        for (int i = 0; i < 10; i++) {
            // 创建一个线程
            new Thread(() -> {

                System.out.println(Thread.currentThread().getName() + "执行");
                countDownLatch.countDown();

            }, "线程" + i).start();
        }

        try {
            countDownLatch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println("全部执行完了");
    }
}
```
#### 8.2 CyclicBarrier

```Java
public class CyclicBarrierDemo {

    public static void main(String[] args) {
        CyclicBarrier cyclicBarrier = new CyclicBarrier(7, () -> {
            System.out.println("召唤神龙");
        });

        for (int i = 1; i <= 7; i++) {
            // 创建一个线程
            int finalI = i;
            new Thread(() -> {

                System.out.println(Thread.currentThread().getName() + "\\t 收集到第" + finalI + "颗龙珠");

                try {
                    cyclicBarrier.await();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                } catch (BrokenBarrierException e) {
                    e.printStackTrace();
                }
            }, String.valueOf(i)).start();
        }
    }
}
```
#### 8.3 Semaphore

在信号量上我们定义 两种操作
- acquire（获取）当一个线程调用 acquire操作时，它要么通过成功获取信号量（信号量减一）
要么一直等下去，直到有线程释放信号量，或超时
- release（释放）实际上会将信号量的值加1，然后唤醒等待的线程

它的使用有2个目的
 * 用于公共资源的互斥使用
 * 用于并发线程数的控制

```Java
public class SemaphoreDemo {

    public static void main(String[] args) {

        Semaphore semaphore = new Semaphore(2);

        for (int i = 0; i < 5; i++) {

            // 创建一个线程
            new Thread(() -> {
                try {
                    semaphore.acquire();
                    System.out.println(Thread.currentThread().getName() + "\\t 抢占到了资源");

                    try {
                        TimeUnit.SECONDS.sleep(3);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }

                    System.out.println(Thread.currentThread().getName() + "\\t 释放了资源");

                } catch (InterruptedException e) {
                    e.printStackTrace();
                } finally {
                    semaphore.release();
                }

            }, "线程" + i).start();

        }
    }
}
```


### 9 ReentrantReadWriteLock读写锁

多个线程可以同时去读取同一个资源类，但是不能同时写入同一个资源类。

 * 读-读能共存
 * 读-写不能共存
 * 写-写不能共存

代码实现一个缓存

```Java
class MyCache {

    private volatile Map<String, Object> map = new HashMap<>();

    private ReadWriteLock readWriteLock = new ReentrantReadWriteLock();

    public void put(String key, Object value) {
        readWriteLock.writeLock().lock();
        try {
            System.out.println(Thread.currentThread().getName() + "\\t---->写入数据" + key);

            try {
                TimeUnit.MILLISECONDS.sleep(300);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            map.put(key, value);
            System.out.println(Thread.currentThread().getName() + "\\t---->写入完成");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            readWriteLock.writeLock().unlock();
        }
    }

    public Object get(String key) {
        readWriteLock.readLock().lock();
        try {
            System.out.println(Thread.currentThread().getName() + "\\t---->读取数据: " + key);
            try {
                TimeUnit.MILLISECONDS.sleep(300);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            Object o = map.get(key);
            System.out.println(Thread.currentThread().getName() + "\\t---->读取完成");
            return o;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            readWriteLock.readLock().unlock();
        }
        return null;
    }
}
public class ReadWriteLockDemo {
    public static void main(String[] args) {

        MyCache myCache = new MyCache();
        for (int i = 0; i < 5; i++) {
            int finalI = i;
            new Thread(() -> {

                myCache.put("线程" + finalI, finalI);

            }, "线程" + i).start();
        }


        for (int i = 0; i < 5; i++) {
            int finalI = i;
            new Thread(() -> {

                myCache.get("线程" + finalI);

            }, "线程" + i).start();
        }
    }
}
```

### 10 BlockingQueueDemo 阻塞队列

阻塞队列是一个队列，线程1往队列里添加元素，线程2从队列中移除元素。

- 当队列为空时，从队列中获取元素就会被阻塞
- 当队列为满的，从队列中添加元素就会被阻塞

为什么要使用BlockingQueue？

我们不再需要关心什么时候需要阻塞线程，什么时候需要唤醒线程，这写操作全部由 BlockingQueue 代劳。

队列的种类

- ArrayBlockingQueue 由数组结构组成的有界阻塞队列
- LinkedBlockingQueue 由链表结构组成的有界（大小默认为integer.MAX_VALUE）阻塞队列
- PriorityBlockingQueue 支持优先排序的无界阻塞队列
- DelayQueue 使用优先级队列实现的延迟无界阻塞队列
- SynchronousQueue 不存储元素的阻塞队列，也即单个元素的队列
- LinkedTransferQueue 由链表组成的无界阻塞队列
- LinkedBlockingDeque 由链表组成的双向阻塞队列




- ThreadPool线程池
- Java8 之流式计算
- 分支合并框架
- 异步回调', 27, 'Java', 'JUC', 1, 49, 0, 0, '2019-11-12 01:58:08', '2019-11-12 01:58:08', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (19, 'HashMap', '', 'http://www.wmding.com/admin/dist/img/rand/34.jpg', '常见HashMap的理解

- HashMap 实现的底层数据结构是怎样的
- 如果发生 Hash 冲突，常见的解决方法？
- JDK 8 中 HashMap 做了什么样的优化
- 红黑树的实现原理是怎样的，相比于链表它的优势和劣势是什么？
- ConcurrentHashMap 是如何做到线程安全的', 27, 'Java', 'HashMap', 0, 0, 0, 0, '2019-11-18 00:05:02', '2019-11-18 00:05:02', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (20, 'Java 并发-各种锁', '', 'http://www.wmding.com/admin/dist/img/rand/3.jpg', '### 1、公平锁和非公平锁
- 公平锁 是指多个线程按照申请锁的顺序来获取锁，先来后到

- 非公平锁 是指多个线程获取锁的顺序并不是按照申请锁的顺序，有可能后申请的线程比先申请的线程优先获取锁。在高并发情况下，有可能会造成优先级反转或者饥饿现象

synchronized 是非公平锁

ReentrantLock 通过构造函数来设定是公平锁还是非公平锁，默认是非公平锁

```Java
// 公平锁
ReentrantLock reentrantLock = new ReentrantLock(true);
// 非公平锁
ReentrantLock reentrantLock = new ReentrantLock();

/**
* Creates an instance of {@code ReentrantLock}.
* This is equivalent to using {@code ReentrantLock(false)}.
*/
public ReentrantLock() {
	sync = new NonfairSync();
}
```

### 2、可重入锁

#### 2.1 是什么
又叫递归锁，指的是同一个线程外层函数获得锁之后，内层递归函数仍然能获取该锁的代码，在同一个线程在外层方法获取锁的时候，在进入内层方法会自动获取锁。

也就是说，线程可以进入任何一个它已经拥有锁所同步着的代码块。
#### 2.2 ReentrantLock/Sychronized 就是典型的可重入锁

#### 2.3 可重入锁最大的作用是避免死锁

#### 2.4 Demo

### 3、独占锁、共享锁

### 4、自旋锁', 27, 'Java', '锁', 1, 25, 0, 0, '2019-11-21 01:34:31', '2019-11-21 01:34:31', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (21, 'Springboot 上传图片失败', '', 'http://www.wmding.com/admin/dist/img/rand/8.jpg', '#### 1 出现问题：
在博客上上传图片时，报错：
>2019-11-23 15:06:48.431 ERROR 8765 --- [nio-8000-exec-6] o.a.c.c.C.[.[.[/].[dispatcherServlet]    : Servlet.service() for servlet [dispatcherServlet] in context with path [] threw exception [Request processing failed; nested exception is org.springframework.web.multipart.MultipartException: Failed to parse multipart servlet request; nested exception is java.io.IOException: The temporary upload location [/tmp/tomcat.6453868963315609813.8000/work/Tomcat/localhost/ROOT] is not valid] with root cause

### 2 出错原因

在Linux 系统中，SpringBoot 应用服务在启动（java -jar 命令启动服务）的时候，会在操作系统的/tmp目录下生成一个tomcat*的文件目录，上传的文件先要转换成临时文件保存在这个文件夹下面。由于临时/tmp目录下的文件，在长时间（10天）没有使用的情况下，就会被系统机制自动删除掉。所以如果系统长时间无人问津的话，就可能导致上面这个问题。

### 3 解决办法



在 MyBlogApplication 中进行修改

```Java
@MapperScan("com.wmding.blog.dao")
@SpringBootApplication(exclude = {MultipartAutoConfiguration.class})
public class MyBlogApplication {

    @Value("${file.path}")
    private String filePath;

    public static void main(String[] args) {
        SpringApplication.run(MyBlogApplication.class, args);
    }

    /**
     * 解决文件上传,临时文件夹被程序自动删除问题
     *
     * 文件上传时自定义临时路径
     * @return
     */
    @Bean
    MultipartConfigElement multipartConfigElement() {
        MultipartConfigFactory factory = new MultipartConfigFactory();
        //该处就是指定的路径(需要提前创建好目录，否则上传时会抛出异常)
        factory.setLocation(filePath);
        return factory.createMultipartConfig();
    }
}
```', 27, 'Java', 'tomcat,上传文件', 1, 31, 0, 0, '2019-11-23 07:40:28', '2019-11-23 07:40:28', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (22, 'JVM学习', '', 'http://www.wmding.com/admin/dist/img/rand/30.jpg', '### 1 JVM 内存模型

<img src="http://47.93.235.138:8000/upload/20191124_15005390.png" alt="Sample"  width="400" height="400">

类装载器
负责加载 class 文件，class 文件在文件开头有特定的文件标识，将 class 文件字节码内容加载到内存中，并将这些内容转换成方法区中的运行时数据结构并且 ClassLoader 只负责 class 文件的加载。它是否可以运行，由 Execution Engine（执行引擎） 决定。

虚拟机自带的加载器
- 启动类加载器（Bootstrap）
- 扩展类加载器（Extension）
- 应用程序类加载器（AppClassLoader）

用户自定义加载器
- Java.lang.ClassLoader 的子类，用户可以根据自己的需要，定制类的加载。

### 2 双亲委派

当一个类收到了类的加载请求时，它首先不会尝试自己去加载这个类，而是把这个请求委派给父类去完成，每一个层次类加载器都是如此，因此所有的加载请求都应该传送到启动类加载器中，只有当父类加载器反馈自己无法完成这个请求的时候，子类加载器才尝试自己去加载

采用双亲委派的好处是：比如加载位于 rt.jar 包中的类 java.lang.Object，不管是哪个加载器加载这个类，都是委派给顶层的启动类加载器进行加载，这样就保证了使用不同的类加载器最终得到的都是同样一个 Object 对象。

### 3 内存模型说明
#### 3.1 程序计数器

PC 寄存器，记录了方法之间的调用和执行情况，类似排版值日表来存储执行下一个指令的地址，也即将要执行的指令代码。他是当前线程所执行的字节码的行号指示器。

#### 3.2 方法区
供各个线程共享的运行时内存区域。它存储了每一个类的结构信息，例如运行时常量池、字段和方法数据、构造函数和普通方法的字节码内容，

#### 3.3 栈
栈内存，主管 Java 程序的运行，是在线程创建时创建，他的生命周期是跟随线程的生命周期，所以栈中没有垃圾回收的问题。8 种基本类型的变量，对象的引用变量，实例方法都是在栈内存中进行分配。

#### 3.4 堆
所有的对象实例以及数组都要在堆上分配，堆中存放访问类元数据的地址

堆分为 新生代（Eden区，From Survivor区，To Survivor区）、老年代

- 新生区

是类的诞生，成长，消亡的区域，一个类在这里产生，应用，最后被垃圾回收器收集，结束生命。新生区分为2个部分：伊甸区（Eden space）和 幸存区（Survivor space）。幸存区有两个：0区和 1区。

当伊甸区的空间用完时，程序又需要创建对象，JVM的垃圾回收器将伊甸区的空间进行垃圾回收（Minor GC），将伊甸园区中的不再被其他对象所引用的对象进行销毁。然后将伊甸园区中剩余的对象移动到幸存 0 区。若幸存 0 区也满了，再对该区进行垃圾回收，然后移动到幸存 1 区。

- 老年区

如果幸存 1 区满了，再移动到养老区。如果养老区也满了，这个时候将产生 MajorGC(Full GC)，进行养老区的内存清理，如果养老区执行了 Full GC 之后发现依然无法进行对象的保存，就会产生 OOM 异常。

出现OOM，说明 Java 虚拟机的堆内存不够，原因：

- Java 虚拟机的堆内存设置的不够，可以通过参数 -Xms,-Xmx来进行调整
- 代码中创建了大量大对象，并且长时间不能被垃圾收集器收集（存在被引用）



##### MinorGC 的过程（复制-》清空-》互换）
1、eden、SurvivorFrom 复制到 SurvivorTo，年龄 +1

首先，当 eden 区满的时候会触发第一次gc，把还活着的对象拷贝到幸存from区，当伊甸园区再次触发gc的时候，会扫描 伊甸园区 和 幸存From 区域，对这两个区域进行垃圾回收，经过这次回收，还存活的对象则直接复制到 To 区域（如果有对象的年龄已经达到老年的标准，则赋值到老年代区）同时把这些对象年龄 +1

2、清空 eden、SurvivorFrom

清空伊甸园区和幸存者from区中的对象，也即 复制之后有交换，谁空谁是To

3、SurvivorTo 和 SurvivorFrom 互换
幸存 To 区和幸存 From 区互换,原幸村 To 区 成为下一次 GC 时的幸存 From 区，部分对象会在 From区 和 To 区中复制来复制去，如此交换15次，最终如果还存活，就存入老年代

------
### 4 GC 是什么
分代收集算法

- 次数上频繁收集 Young 区
- 次数上较少收集 Old 区
- 基本不动元空间

### 4 GC 算法
GC 4算法：

- 引用计数法
每次对对象赋值时均要维护引用计数器，且计数器本身也有一定的消耗；
比较难处理循环引用

JVM 的实现一般不采用这种方式

- 复制算法（Copying）

从根集合（GC Root）开始，通过 Tracing 从 From 中找到存活对象，拷贝到 To 区

From 和 To 交行身份，下次内存分配从 To 开始

年轻代中的 GC ，主要就是复制算法。
将内存分为两块，每次只用其中一块，当这一块内存用完，就将还活着的对象复制到另一块上，复制算法不会产生内存碎片


- 标记清除（Mark-Sweep）

分为标记和清除两个阶段，先标记出要回收的对象，然后统一回收这些对象。不需要额外的空间，但是需要2次扫描，耗时严重；会产生内存碎片

- 标记压缩（Mark-Compact）

标记（与标记清除一样）和压缩，再次扫描，并往一端滑动存活对象

没有碎片，需要移动对象的成本。', 27, 'Java', 'JVM', 1, 72, 0, 0, '2019-11-24 07:30:03', '2019-11-24 07:30:03', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (23, 'Java学习目录', '', 'http://www.wmding.com/admin/dist/img/rand/11.jpg', '## 1、Java 基础

[Java基础](http://www.wmding.com/blog/13 "Java基础")

[Java中equals()的若干问题解答](http://www.wmding.com/blog/14 "Java中equals()的若干问题解答")

## 2、容器

## 3、并发相关

[JUC包学习](http://www.wmding.com/blog/18 "JUC包学习")

[多线程学习](http://www.wmding.com/blog/16 "多线程学习")

[synchronized和Lock有什么区别](http://www.wmding.com/blog/12 "synchronized和Lock有什么区别")

## 4、JVM相关

[JVM](http://www.wmding.com/blog/22 "JVM")


## 5、数据结构与算法

### 5.1、数据结构

### 5.2 算法

## 6、数据库相关

### 6.1、MySQL


### 6.2、Redis

## 7、设计模式相关
[单例模式](http://www.wmding.com/blog/9 "单例模式")

[观察者模式](http://www.wmding.com/blog/11 "观察者模式")

[策略模式](http://www.wmding.com/blog/10 "策略模式")

[代理模式](http://www.wmding.com/blog/7 "代理模式")

## 8、其他

### 8.1、Linux 
[linxu](http://www.wmding.com/blog/8 "linxu")', 27, 'Java', 'Java', 1, 57, 0, 0, '2019-11-25 13:38:29', '2019-11-25 13:38:29', '1');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (24, 'CAS 你知道吗？', '', 'http://www.wmding.com/admin/dist/img/rand/32.jpg', '### 0、CAS的一系列问题
 CAS-->UnSafe-->CAS底层思想-->ABA-->原子引用更新-->如何规避ABA问题

### 1、CAS 是什么？
CAS:compareAndSet 比较并交换，它是一条CPU的并发原语

它的功能是判断内存某个位置的值是否为预期值，如果是则更改为新的值，这个过程是原子的。

### 2、底层原理是什么，为什么不用synchronized
  1、自旋锁
  2、unsafe

```
  atomicInteger.getAndIncrement();

 public final int getAndIncrement() {
    return unsafe.getAndAddInt(this, valueOffset, 1);
  }
```
 *  this：当前对象
 *  valueOffset：内存偏移量（内存地址）

1、Unsafe 是rt.jar包中的 sun.misc

是CAS的核心类，由于Java是无法直接访问底层系统，需要通过本地（Native）方法来访问，

Unsafe相当于一个后门，基于该类可以直接操作特定内存的数据。
其内部方法操作可以像C的指针一样直接操作内存，因为Java中的CAS操作的执行依赖于该类的方法

2、valueOffset表示该变量在内存中的偏移地址，因为Unsafe就是根据内存偏移量地址获取数据的

3、变量value使用了volatile来进行修饰，保证了多线程之间的内存可见性

假如线程A和线程B同时执行 getAndIncrement 操作
* 1、假设AtomicInteger里面的初始值为 3，即主物理内存中的 AtomicInteger 的value值为3，根据JMM模型，线程A和线程B各自都持有一个值为 3 的副本分别到各自的内存空间

* 2、线程A通过 getIntVolatile(var1, var2);拿到value的值 3，这个时候线程A被挂起

* 3、线程B也通过 getIntVolatile(var1, var2);拿到value的值 3。此时线程B没有被挂起并执行了compareAndSwapInt(var1, var2, var5, var5 + var4) 方法，比较内存中的值也为 3 ，所以成功修改该值变为了4，

* 4、线程A恢复，执行 compareAndSwapInt(var1, var2, var5, var5 + var4) 方法 ，发现自己内存中的值3和主内存中的值4不一致，也就是发现被别人修改了，那本次修改就失败，然后继续循环
* 5、线程A循环，比较替换，直至成功

### 3、CAS的缺点
1、如果CAS失败，会一直尝试，如果CAS长时间不一致，会给CPU带来压力（循环时间长开销较大）

2、只能保证一个共享变量的原子操作

3、引出来ABA问题

### 4、ABA问题
 *  1、原值为3
 *  2、线程A操作了主物理内存中的值从3改为了4，然后由将4改为了3。
 *  3、线程B去进行判断时，认为没有线程修改，但其实线程A已经操作过了

### 5、如何解决ABA问题

 * 原子引用 + 新增一种机制，那就是修改版本号（类似时间戳）
 *  AtomicStampedReference', 27, 'Java', 'CAS', 1, 59, 0, 0, '2019-11-28 08:10:52', '2019-11-28 08:10:52', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (25, '经典语录', '', 'http://www.wmding.com/admin/dist/img/rand/29.jpg', '### 1、杂录

- 一百次中有九十九次，没有人会为了任何一桩事情来责备他自己，即使他犯下的错误十分严重
- 无论是谁所做的事，都起源于两种根本动力：一是性的冲动；二是想要成功的欲望。(二十世纪最享盛誉的心理学家西格蒙德·弗洛伊德)
- 时光永远向前，而不会重新来过。因此，若我能为任何人谋得任何有利于他的事，都应立时实行，毫无吝啬，不推脱也不漠视，因为这一刻过去了就无法重来。
- 假如你想让别人听你的话，首要途径就是引发他人的强烈欲求。胜者坐拥天下，败者踽踽独行


--------

### 2、可能会改变你的话(两年内收集的33条Awesome Tips)[原文链接](https://juejin.im/post/5e13e8265188253a887bb44c "原文链接")

#### 1.一个浪头打过来，最好的办法是迎上去了解个究竟，而不是漠视，或者干脆当事情没有发生。

#### 2.记住这个教训：别猜，去问！去查！

#### 3.隔一段时间重顾知识是记忆的关键方法。不要一次性学完一项知识就不管了，
这样你无法真正的掌握。隔一段时间回顾一下，每次重复，你都会加深自己的
理解，次数多了，你就会理解每个细节，成为真正的专家。

#### 4.对于一个技术通常我们需要抱有这样的疑问

它是什么 一句话概括
解决了什么问题 存在的意义
怎样去使用它
怎样解决了问题 内部的实现
它的缺点是什么 多角度分析

#### 5.高效率的学习方法。

理清楚概念很重要
做好控制变量法
多动手实践，与理论结合
抓住重点，剔除干扰因素

#### 6.关于如何选择第三方库

确定这个库是否是必需的
这个库能否带来开发效率的提升，降低代码的维护成本
这个库的学习成本如何 比如rxjava其实学习成本会相对高一些。
这个库的质量如何，不要仅仅看star，更要看issue的处理情况。

#### 7.怎样练习算法题？

每道算法题都先自己去实现，先写思路，然后自己去实现一遍，然后再看看答
案，记住答案的思路，第二天再重新按照答案的思路实现一遍。

#### 8."另类"的学习方法

抄书的奥妙——那就是延缓阅读速度，不至遗漏每一个重要的细节：眼到，手到，
心到，其实不仅书抄得，代码(优秀源码)也抄得。

#### 9.建议：建立逐字稿

计算机网络相关的逐字稿
计算机操作系统相关的逐字稿
数据库相关的逐字稿
设计模式相关的逐字稿
数据结构与算法相关的逐字稿
Java知识相关的逐字稿
Kotlin知识相关的逐字稿
Python知识相关的逐字稿
React Native知识相关的逐字稿
Flutter知识相关的逐字稿
小程序知识相关的逐字稿
JS知识相关的逐字稿
Android知识相关的逐字稿
与技术无关的逐字稿

#### 10.如何提升你的阅读能力？

只字不差的反复阅读
真正的获取知识，是通过阅读，深入思考与践行

#### 11.如何高效阅读一篇文章？

由主题扩展为知识树
尝试描述
尝试记忆

#### 12.如何阅读源码？

流程：
- 1.寻找驱动力
- 2.浏览官方文档，对开源项目的功能、架构有大概的印象
- 3.在工作中或实践中使用开源项目
- 4.网上搜索针对该开源项目进行分析的优秀文章
- 5.对开源项目提出自己的疑问
- 6.把开源项目下载到本地，并导入IDE，方便调试、测试
- 7.带着疑问阅读源码
- 8.阅读源码过程中多添加注释、多做笔记
- 9.做阅读总结，吸收和再创造

准备：
- Java设计模式(模板方法，单例，观察者，工厂方法，代理，策略，装饰者)，
- Java高级相关
- 熟练掌握这个库
- 先Google了解软件的整体架构设计
- 搭建系统，把源码跑起来

开始阅读：
- 根据你对系统的理解，设计几个主要的测试案例，定义好输入，输出。(Debug一
- 遍肯定是不行的，需要Debug很多遍)
- 第一篇抛弃细节，抓住主要流程，第二篇，第三篇，再去看各个部分的细节。
- 阅读的时候同时使用UML画出系统的类图。
- 主要的测试案例明白了，丰富测试案例，考虑一些分支。
- 这一步会非常非常地花费时间，但是你做完了，对系统的理解绝对有质的飞跃。

#### 13.想象一个来自未来的自己，他非常自信，非常成功，
拥有你现在所希望的一切，他会对现在的你说些什么？
他怎么说，你就怎么去做，10年之后，你就变成了他。

#### 14.重视实践，充分运用感性认知潜能，在项目中磨炼自
己，才是正确的学习之道。在实践中，在某些关键动作
上刻意练习，也会取得事半功倍的效果。

#### 15.我们需要从别人身上学习。从老师、领导、同事、下属甚至对手身上学习，是快速成长的重要手段。

#### 16.多多总结，多多分享，善莫大焉。

#### 17.解答别人的问题也是个人成长的重要手段。
有时候，某个问题自己本来不太懂，但是在给别人讲解的时候却
豁然开朗。所以，“诲人不倦”利人惠己。

#### 18.学习计划最好能结合工作计划，理论联系实际结合，快速学以致用。

#### 19.良好的用人方式应该如下：

- 首选选择相信，在面临失败后，收缩信任度。

- 查找失败的原因，提供改进意见，提升下属的能力。

- 总是给下属机会，在恰当地时机给下属更高的挑战。 

- 总之，苍天大树来自一颗小种子，要相信成长的力量。

#### 20.学习就是不断地刻意联系，刻意练习，就是有目的的练习，先规划好，再去练习。
首先给自己定一个目标，目标可以有效的引导你学习，然后使用3F练习法：

- 1： 专注（Focus），专注在眼前的任务上，在学习过程中保持专注，可以尝试使用番茄工作法。

- 2：反馈（Feedback），意识到自己的不足，学习完之后进行反思，思考下自己哪些方面不足，为什么不足，

- 3： 修正（Fix），改进自己的不足。

不停的练习和思考可以改变大脑结构，大脑像肌肉一样，挑战越大，影响越大，学习更高效，并且也会产生突破性。

#### 21.写一篇博客的过程，其实就是对一件事情，学习、理解、思考、转化，最终输出成一篇博客的过程。

#### 22.深入浅出SQL给出的学习法则：

如何快速记忆知识？
将文字转换为图片（将文字嵌入图片效果比较好)，如果能转换为令人惊奇，
有趣的情景模拟，那么可以让你的大脑意识到这是重要的东西，记忆效果会更好。

- 1.慢慢来，理解越多，需要强记得就越少。

- 2.勤做笔记，写下你的心得笔记。

- 3.你的大脑会需要一段时间来消化新知识，如果之后再学别的知识，会使之前
的记忆效果减弱，因此，在睡前看最重要的知识。

- 4.喝水，多喝水。

- 5.大声说出你想要记忆的知识，如果能与别人进行一问一答则效果更佳。

- 6.当学习知识时，达到了漫不经心或过目即忘的状态，则应该让大脑好好休息。

- 7.用心感受，让你的大脑知道这很重要，将学习的内容尽量以情景化+惊奇+幽默的形式展示出来。

- 8.用学到的知识解决实际的难题（真实的情景演练）。

#### 23.想要学习新技术，想要提升自己，不是看见新技术就去学，沉下心来认真钻研才行，吃透它，不再为缓解焦虑而学习。

#### 24.业务代码一样很牛逼

- 1.使用封装和抽象可以使业务代码更具扩展性。
- 2.多和产品交流以便更好地理解和实现业务。
- 3.日志记录好了问题定位效率可以提升10倍。

#### 25.在工作中学习、实战提升是效果最好的，其余时间可有目的去碎片化学习一整块知识，也可以快速构建牢固的知识体系。

#### 26.做更多：工作中熟悉多个业务代码，端到端（前后端）的业务代码，自学。

做更好：
- 1.提升项目稳定性，引进单元测试和UI测试。
- 2.重构解耦项目。
- 3.性能优化。
- 4.设计模式去除重复代码。

做练习：
- 1.学习
- 2.尝试
- 3.教学

#### 27.一项新技术的出现，应该先去了解它，看它是否对自身的技术成长有比较大的帮助，有的话按优先级加入计划表

#### 28.重复记忆时间间隔：1小时、早上/晚上、1天、3天、7天、1个月、3个月形成长期记忆~

#### 29.学习一个新的知识点的流程：
what、why、how、原理/源码、优缺点~
注意”先主后从“原则，多实践加深理解。

#### 30.真正地掌握一个知识点：

- 1.看书、博客和源码学习

- 2.看的过程中要把书中的例子都敲一遍，所有的代码都要亲自敲，不要使用复制
粘贴，相信我，复制粘贴达不到你想要的效果

- 3.看的过程中多思考，多总结，多验证，把关键点和自己的思考总结写成博客或者笔记，于人于己都是好事

- 4.一个个的知识点重复上述的三个过程，并坚持下来

31.高效学习:

- 1.源头：一手资料
- 2.基础知识和原理
- 3.思维导图实现知识地图

（注意：根节点即为一个技术最重要最主干的地方，也可以应用在重要的问题上面，最后实现一个倒树结构）

#### 31.系统学习一门技术：
- 1.成因和目标
- 2.优势和劣势
- 3.适用场景（业务场景和技术场景）
- 4.组成部分和关键点
- 5.底层原理和关键实现
- 6.已有实现和它之间的比较

#### 32.牢记三大沟通方式：尊重对方、倾听对方和情绪控制。
沟通的目的不是为了附和对方，而是产生一种更完整更全面的认知。只有当双方都愿意接受不同的观点时，此时的沟通才会迸发出更多的火花，而这一切都需要发生在相互尊重的基础之上。

#### 33.学习的第一步是知道自己学习的这个知识问题是什么，答案是什么，然后找到这些问题和答案之间的关系，这个关系是我们需要学习的东西，最后能把这个关
系通过通俗易懂的语言输出出来，那么这个知识你一定学会了。', 24, '日常随笔', '经典语录', 1, 84, 0, 0, '2019-11-29 02:56:39', '2019-11-29 02:56:39', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (26, 'mongo', '', 'http://www.wmding.com/admin/dist/img/rand/10.jpg', '### 1、使用 docker 安装 MongoDB

```java
docker search mongo

docker pull mongo

docker images

docker run -p 27017:27017 -v $PWD/db:/data/db -d mongo:3.2
//-p 27017:27017 :将容器的27017 端口映射到主机的27017 端口
//-v $PWD/db:/data/db :将主机中当前目录下的db挂载到容器的/data/db，作为mongo数据存储目录

docker ps

docker run -it mongo:3.2 mongo --host 172.17.0.1

docker exec -it mongodb-server0 mongo admin
```', 26, 'Linux', 'MongoDB', 1, 8, 0, 0, '2020-02-28 13:19:44', '2020-02-28 13:19:44', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (27, '高并发系统的通用设计方法', '', 'http://www.wmding.com/admin/dist/img/rand/38.jpg', '### 1、三种应对高并发的方法
- Scale-out(横向扩展)：分布式部署服务
- 缓存：将热点数据进行提前缓存
- 异步：请求先返回，之后等数据准备好后在告知调用方

### 2、Scale-out

Scale-up pk Scale-out

Scale-up (纵向扩展)，通过购买性能更好的硬件来提升系统的并发处理能力。比如现在硬件是 4核4G每秒处理 200 次请求，为了能处理每秒 400 次请求，那就可以硬件提升更高，比如 8核 8G。

Scale-out 通过多个低性能机器来组成一个分布式集群来共同抵御高并发流量的冲击。

会引入一些问题：
- 某一个节点故障如何保证整体可用性
- 当多个节点有状态需要进行同步时，如何保证状态信息在不同节点的一致性。
- 如何在不影响系统可用的情况下，进行节点的增加和删除

### 3、缓存

使用缓存来提升系统的访问性能，在高并发场景下支撑更多用户的同时访问。

从磁盘中读取数据，是最慢的，通常使用以内存作为存储介质的缓存，来提升性能。

### 4、异步处理
分布式服务框架 Dubbo 中有同步方法调用和异步方法调用，IO 模型中有同步 IO 和异步 IO。


#### 4.1、同步
以方法调用为例，同步调用代表调用方要阻塞等待被调用方法中的逻辑执行完成。
这种方式下，当被调用方法响应时间较长时，会造成调用方长久的阻塞，在高并发下会造成整体系统性能下降，甚至发生雪崩。

#### 4.2、异步
调用方不需要等待方法逻辑执行完成就可以返回执行其他的逻辑，在被调用方法执行完毕后再通过回调、事件通知等方式将结果反馈给调用方

### 5、系统演进过程应该遵循的思路
- 最简单的系统设计满足业务需求和流量现状，选择最熟悉的技术体系。
- 随着流量的增加和业务的变化修正架构中存在问题的点，如单点问题、横向扩展问题、性能无法满足需求的组件。在这个过程中，选择社区成熟的、团队熟悉的组件帮助我们解决问题，在社区没有合适解决方案的前提下才会自己造轮子。
- 当对架构的小修小补无法满足需求时，考虑重构、重写等大的调整方式以解决现有的问题。', 27, 'Java', '高并发', 1, 11, 0, 0, '2020-03-03 12:35:45', '2020-03-03 12:35:45', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (28, '架构分层', '', 'http://www.wmding.com/admin/dist/img/rand/21.jpg', '随着业务越来越复杂，大量的代码纠缠在一起，会出现逻辑不清晰、各模块相互依赖、代码扩展性差、改动一处就牵一发而动全身等问题

### 1、常见的分层

#### 1.1、MVC

将用户视图和业务处理隔离开，并且通过控制器连接起来，很好的实现了表现和逻辑的解耦。

#### 1.2、另一种分层

- 表现层，顾名思义嘛，就是展示数据结果和接受用户指令的，是最靠近用户的一层
- 逻辑层里面有复杂业务的具体实现
- 数据访问层则是主要处理和存储之间的交互。

#### 1.3 其他分层思想

OSI 网络模型，分为 7 层，从下到上：物理层、数据链路层、网络层、传输层、会话层、表现层、应用层。

TCP/IP 协议，它把网络简化成了四层，即链路层、网络层、传输层和应用层

### 2、分层有什么好处？

- 分层的设计可以简化系统设计，让不同的人专注做某一层次的事情。
- 分层之后可以做到很高的复用
- 分层架构可以让我们更容易做横向扩展', 27, 'Java', '架构分层', 1, 6, 0, 0, '2020-03-03 13:43:09', '2020-03-03 13:43:09', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (29, '如何提升系统性能', '', 'http://www.wmding.com/admin/dist/img/rand/20.jpg', '### 1、高并发系统设计的三大目标：高性能、高可用、可扩展

- 性能，反应了系统的使用体验，例如，同样承担每秒一万次请求的两个系统，一个响应时间是毫秒级的，一个是秒级别，这样它们带给用户的体验肯定不同的。
- 可用性表示系统可以为正常服务用户的时间。类比一下，还是两个承担每秒一万次请求的两个系统，一个系统可以全年不停机、无故障；另一个隔三差五的宕机维护
- 可扩展性，流量一般分为平时流量和峰值流量，峰值流量可能会是平时流量的几倍甚至几十倍，在应对峰值流量时，就要在架构和方案上做更多的准备。比如双十一前的准备，明星事件等。易于扩展的系统能在较短的时间内迅速完成扩容，更加平稳的承担峰值流量。

### 2、性能优化的原则

- 性能优化一定不能盲目，一定是问题导向的。如果脱离了实际问题，盲目的提早优化会增加系统的复杂度，并浪费人力，这种是不可取的。
- 性能优化也遵循”八二原则“，即你可以用 20%的精力去解决 80% 的性能问题。所以我们在优化过程中需要抓住主要矛盾，优化主要的性能瓶颈
- 性能优化需要有数据支撑。即了解你的优化让响应时间减少了多少，提升了多少吞吐量。
- 性能优化的过程是持续的，需要不断的解决性能瓶颈。

### 3、性能的度量指标

我们需要有度量的指标，有了数据才能明确目前存在的性能问题，也能够用数据来评估性能优化的效果。


- 平均值
- 最大值
- 分位值
  分位值有很多种，比如 90 分位、95 分位、75 分位。以 90 分位为例，我们把这段时间请求的响应时间从小到大排序，假如一共有 100 个请求，那么排在第 90 位的响应时间就是 90 分位值。分位值排除了偶发极慢请求对于数据的影响，能够很好地反应这段时间的性能情况，分位值越大，对于慢请求的影响就越敏感。

响应时间控制在多久比较合适呢？

从用户体验的角度来说：
- 200ms是第一个分界点，感觉不到，体验极好
- 1s是一个分界点，可以感觉到有延迟，但可以接受
- 超过1s，有明显的等待，基本不能接受

健康系统的 99 分位值的响应时间通常通知在 200 ms 之内，不超过 1s 的请求占比要在 99.99% 以上。

### 4、高并发下的性能优化

#### 1、提升系统的处理核心数

增加系统的并行处理能力

#### 2、减少单次任务的响应时间

先看系统是 CPU 密集型还是 IO 密集型

CPU密集型系统中，需要处理大量的 CPU 运算，那么选用更高效的算法或者减少运算次数就是这类系统重要的优化手段。

IO 密集型系统指的是系统的大部分操作是在等待 IO 完成，

- 磁盘 IO
- 网络 IO

  我们熟知的系统大部分都属于 IO 密集型，比如数据库系统、缓存系统、Web 系统。这类系统的性能瓶颈可能出在系统内部，也可能是依赖的其他系统，而发现这类性能瓶颈的手段主要有两类：

- 采用工具

  Linux 的工具集很丰富，完全可以满足你的优化需要，比如网络协议栈、网卡、磁盘、文件系统、内存，等等

- 通过监控来发现性能问题。

  在监控中我们可以对任务的每一个步骤做分时的统计，从而找到任务的哪一步消耗了更多的时间。

### 5、总结

- 数据优先，你做一个新的系统在上线之前一定要把性能监控系统做好；
- 掌握一些性能优化工具和方法，这就需要在工作中不断的积累；
- 计算机基础知识很重要，比如说网络知识、操作系统知识等等，掌握了基础知识才能让你在优化过程中抓住性能问题的关键，也能在性能优化过程中游刃有余', 27, 'Java', '高并发', 1, 9, 0, 0, '2020-03-04 13:21:18', '2020-03-04 13:21:18', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (30, '系统怎样做到高可用', '', 'http://www.wmding.com/admin/dist/img/rand/32.jpg', '高可用(High Avaliability, HA)，指的是系统具备较高的无故障运行的能力。

### 1、可用性的度量
- MTBF
  MTBF（Mean Time Between Failure）：平均故障间隔，代表两次故障的间隔时间，也就是系统正常运转的平均时间，这个时间越长，系统稳定性就越高
- MTTR
  MTTR（Mean Time To Repair）：故障的平均恢复时间，也就是平均故障的时间。这个值越小，故障对于用户的影响也就越小。

> Availability = MTBF / (MTBF + MTTR)

![](http://47.93.235.138:8000/upload/20200305_11380143.jpg)

一般来说，我们的核心的业务系统的可用性，需要达到 四个九；非核心系统的可用性最多容忍到 三个九。

### 2、高可用系统设计思路
#### 2.1、系统设计

“Design for failure”是我们做高可用系统设计时秉持的第一原则。

- failover（故障转移）

  1、完全对等的节点之间做 failover，一个节点不可用时，直接访问另一个节点。

  2、不对等的节点之间（系统中存在主节点也存在备节点）。比方说我们有一个主节点，有多台备用节点，这些备用节点可以是热备（同样在线提供服务的备用节点），也可以是冷备（只作为备份使用），那么我们就需要在代码中控制如何检测主备机器是否故障，以及如何做主备切换。
  
  使用最广泛的故障检测机制是“心跳”。你可以在客户端上定期地向主节点发送心跳包，也可以从备份节点上定期发送心跳包。当一段时间内未收到心跳包，就可以认为主节点已经发生故障，可以触发选主的操作。
- 超时控制
  复杂的高并发系统通常会有很多的系统模块组成，同时也会依赖很多的组件和服务，比如说缓存组件，队列服务等等。它们之间的调用最怕的就是延迟而非失败，因为失败通常是瞬时的，可以通过重试的方式解决。而一旦调用某一个模块或者服务发生比较大的延迟，调用方就会阻塞在这次调用上，它已经占用的资源得不到释放。当存在大量这种阻塞请求时，调用方就会因为用尽资源而挂掉
- 降级是为了保证核心服务的稳定而牺牲非核心服务的做法
- 限流，它通过对并发的请求进行限速来保护系统。

#### 2.2、系统运维
- 灰度发布
- 故障演练', 27, 'Java', '高可用', 1, 6, 0, 0, '2020-03-05 03:38:56', '2020-03-05 03:38:56', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (31, '如何让系统易于扩展', '', 'http://www.wmding.com/admin/dist/img/rand/2.jpg', '在热点事件发生时，流量瞬间提升到 2~3倍甚至更高，最快的方式就是堆机器，但需要保证，在扩容了三倍的机器后，相应的系统也能支撑三倍的流量。

### 1、为什么提升扩展性会很复杂

集群系统中，不同的系统分层上可能存在一些瓶颈点，这些瓶颈点制约着系统的横向扩展能力，比如：系统的流量是每秒1000次请求，对数据库的请求量也是每秒1000次，如果流量增加了10倍，虽然系统可以通过扩容正常服务，但是数据库却成了瓶颈。

如果多数据库也进行扩容，存储集群中增加或者减少机器时，会涉及到大量数据的迁移，一般传统的关系型数据库都不支持。

站在整体的架构的角度，不仅仅是业务服务器的角度来考虑系统的扩展性，数据库、缓存、依赖的第三方、负载均衡、交换机带宽等都是系统扩展需要考虑的因素。

### 2、高可扩展行的设计思路

拆分是提升系统扩展性最重要的一个思路，将一个庞杂的系统拆分成独立的，有单一职责的模块。即将复杂问题简单话。
- 存储层的扩展性
- 业务层的扩展性

### 3、redis 扩展

redis扩展主要两方面。主备方案以及集群方案。

- 主备
  用 redis 的 sentinel（哨兵）方案主要是解决 redis 主节点故障后的自动切换。它负责持续监控主从节点的健康，当主节点挂掉时，自动选择一个最优的从节点切换为主节点。

- 集群方案

  - codis
  - edis官方提供的cluster。', 27, 'Java', '可扩展性', 1, 5, 0, 0, '2020-03-05 12:57:34', '2020-03-05 12:57:34', '0');
INSERT INTO my_blog_db.tb_blog (blog_id, blog_title, blog_sub_url, blog_cover_image, blog_content, blog_category_id, blog_category_name, blog_tags, blog_status, blog_views, enable_comment, is_deleted, create_time, update_time, top) VALUES (32, 'Redis基本使用记录', '', 'http://www.wmding.com/admin/dist/img/rand/20.jpg', '### 1、简介
Redis：开源、免费、高性能、K-V数据库、内存数据库、非关系型数据库，支持持久化、集群和事务

### 2、Redis安装及配置
#### 2.1、ocker运行Redis

```
docker pull redis
docker run -d --name redis -p 6379:6379 redis
docker exec -it redis redis-cli
```
#### 2.2、Linux安装

- 确保Linux已经安装gcc
- 下载Redis
```Java
wget http://download.redis.io/releases/redis-4.0.1.tar.gz
```
- 解压
```
tar -zxvf redis-4.0.1.tar.gz
```
- 进入目录后编译
```Java
cd redis-4.0.1
make MALLOC=libc
```
- 安装
```
make PREFIX=/usr/local/redis install #指定安装目录为/usr/local/redis
```
- 启动
```
/usr/local/redis/bin/redis-server
```
### 3、Redis配置
#### 3.1、修改redis.conf文件

```
启动自定义配置的Redis
/usr/local/redis/bin/redis-server /usr/local/redis/redis.conf
```

#### 3.2、配置详解
- daemonize ： 默认为no，修改为yes启用守护线程
- port ：设定端口号，默认为6379
- bind ：绑定IP地址
- databases ：数据库数量，默认16
- save <second> <changes> ：指定多少时间、有多少次更新操作，就将数据同步到数据文件
- redis默认配置有三个条件，满足一个即进行持久化
- save 900 1 #900s有1个更改
- save 300 10 #300s有10个更改
- save 60 10000 #60s有10000更改
- dbfilename ：指定本地数据库的文件名，默认为- dump.rdb
- dir ：指定本地数据库的存放目录，默认为./当前文件夹
- requirepass ：设置密码，默认关闭
redis -cli -h host -p port -a password

### 4、Redis关闭

- 使用kill命令 (非正常关闭，数据易丢失)
ps -ef|grep -i redis
kill -9 PID
- 正常关闭
redis-cli shutdown


### 5、常用命令记录

Redis五种数据类型：string、hash、list、set、zset

#### 5.1、一般常用命令
```
DEL key
DUMP key：序列化给定key，返回被序列化的值
EXISTS key：检查key是否存在
EXPIRE key second：为key设定过期时间
TTL key：返回key剩余时间
PERSIST key：移除key的过期时间，key将持久保存
KEY pattern：查询所有符号给定模式的key
RANDOM key：随机返回一个key
RANAME key newkey：修改key的名称
MOVE key db：移动key至指定数据库中
TYPE key：返回key所储存的值的类型
```

#### 5.2、EXPIRE key second的使用场景：
1、限时的优惠活动
2、网站数据缓存
3、手机验证码
4、限制网站访客频率

#### 5.3、key的命名建议
- key不要太长，尽量不要超过1024字节。不仅消耗内存，也会降低查找的效率
- key不要太短，太短可读性会降低
- 在一个项目中，key最好使用统一的命名模式，如user:123:password
- key区分大小写

### 6、不同类型的数据

#### 6.1、string
>string类型是二进制安全的，redis的string可以包含任何数据，如图像、序列化对象。一个键最多能存储512MB。==二进制安全是指，在传输数据的时候，能保证二进制数据的信息安全，也就是不会被篡改、破译；如果被攻击，能够及时检测出来 ==

```
setkey_name value：命令不区分大小写，但是key_name区分大小写
SETNX key value：当key不存在时设置key的值。（SET if Not eXists）
get key_name
GETRANGE key start end：获取key中字符串的子字符串，从start开始，end结束
MGET key1 [key2 …]：获取多个key
GETSET KEY_NAME VALUE：设定key的值，并返回key的旧值。当key不存在，返回nil
STRLEN key：返回key所存储的字符串的长度
INCR KEY_NAME ：INCR命令key中存储的值+1,如果不存在key，则key中的值话先被初始化为0再加1
INCRBY KEY_NAME 增量
DECR KEY_NAME：key中的值自减一
DECRBY KEY_NAME
append key_name value：字符串拼接，追加至末尾，如果不存在，为其赋值
```

##### String应用场景：

- 1、String通常用于保存单个字符串或JSON字符串数据
- 2、因为String是二进制安全的，所以可以把保密要求高的图片文件内容作为字符串来存储
- 3、计数器：常规Key-Value缓存应用，如微博数、粉丝数。INCR本身就具有原子性特性，所以不会有线程安全问题

#### 6.2、hash
>Redis hash是一个string类型的field和value的映射表，hash特别适用于存储对象。每个hash可以存储232-1键值对。可以看成KEY和VALUE的MAP容器。相比于JSON，hash占用很少的内存空间。

常用命令
```
HSET key_name field value：为指定的key设定field和value
hmset key field value[field1,value1]
hget key field
hmget key field[field1]
hgetall key：返回hash表中所有字段和值
hkeys key：获取hash表所有字段
hlen key：获取hash表中的字段数量
hdel key field [field1]：删除一个或多个hash表的字段
```
##### 应用场景

Hash的应用场景，通常用来存储一个用户信息的对象数据。
- 1、相比于存储对象的string类型的json串，json串修改单个属性需要将整个值取出来。而hash不需要。
- 2、相比于多个key-value存储对象，hash节省了很多内存空间
- 3、如果hash的属性值被删除完，那么hash的key也会被redis删除

#### 6.3、list
类似于Java中的LinkedList。

常用命令
```
lpush key value1 [value2]
rpush key value1 [value2]
lpushx key value：从左侧插入值，如果list不存在，则不操作
rpushx key value：从右侧插入值，如果list不存在，则不操作
llen key：获取列表长度
lindex key index：获取指定索引的元素
lrange key start stop：获取列表指定范围的元素
lpop key ：从左侧移除第一个元素
prop key：移除列表最后一个元素
blpop key [key1] timeout：移除并获取列表第一个元素，如果列表没有元素会阻塞列表到等待超时或发现可弹出元素为止
brpop key [key1] timeout：移除并获取列表最后一个元素，如果列表没有元素会阻塞列表到等待超时或发现可弹出元素为止
ltrim key start stop ：对列表进行修改，让列表只保留指定区间的元素，不在指定区间的元素就会被删除
lset key index value ：指定索引的值
linsert key before|after world value：在列表元素前或则后插入元素
```
##### 应用场景

- 1、对数据大的集合数据删减
列表显示、关注列表、粉丝列表、留言评价...分页、热点新闻等
- 2、任务队列
list通常用来实现一个消息队列，而且可以确保先后顺序，不必像MySQL那样通过order by来排序

补充：
rpoplpush list1 list2 移除list1最后一个元素，并将该元素添加到list2并返回此元素
用此命令可以实现订单下单流程、用户系统登录注册短信等。

#### 6.4、set
唯一、无序
```
sadd key value1[value2]：向集合添加成员
scard key：返回集合成员数
smembers key：返回集合中所有成员
sismember key member：判断memeber元素是否是集合key成员的成员
srandmember key [count]：返回集合中一个或多个随机数
srem key member1 [member2]：移除集合中一个或多个成员
spop key：移除并返回集合中的一个随机元素
smove source destination member：将member元素从source集合移动到destination集合
sdiff key1 [key2]：返回所有集合的差集
sdiffstore destination key1[key2]：返回给定所有集合的差集并存储在destination中
```
##### 对两个集合间的数据[计算]进行交集、并集、差集运算

- 1、以非常方便的实现如共同关注、共同喜好、二度好友等功能。对上面的所有集合操作，你还可以使用不同的命令选择将结果返回给客户端还是存储到一个新的集合中。
- 2、利用唯一性，可以统计访问网站的所有独立 IP

#### 6.5、zset
有序且不重复。每个元素都会关联一个double类型的分数，Redis通过分数进行从小到大的排序。分数可以重复
```
ZADD key score1 memeber1
ZCARD key ：获取集合中的元素数量
ZCOUNT key min max 计算在有序集合中指定区间分数的成员数
ZCOUNT key min max 计算在有序集合中指定区间分数的成员数
ZRANK key member：返回有序集合指定成员的索引
ZREVRANGE key start stop ：返回有序集中指定区间内的成员，通过索引，分数从高到底
ZREM key member [member …] 移除有序集合中的一个或多个成员
ZREMRANGEBYRANK key start stop 移除有序集合中给定的排名区间的所有成员(第一名是0)(低到高排序）
ZREMRANGEBYSCORE key min max 移除有序集合中给定的分数区间的所有成员
```
常用于排行榜：
- 1、如推特可以以发表时间作为score来存储
- 2、存储成绩
- 3、还可以用zset来做带权重的队列，让重要的任务先执行', 27, 'Java', 'Redis', 1, 16, 0, 0, '2020-03-06 08:28:36', '2020-03-06 08:28:36', '0');