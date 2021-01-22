#  vacation plugin

Redmine 假期管理插件。在原有工时登记基础上添加加班工时审批、请假管理等。

## 1.开发环境搭建

按照 官方文档(http://www.redmine.org/projects/redmine/wiki/Plugin_Tutorial)说明,新的插件可以使用插件生成器直接生成语法为：

`bundle exec ruby bin/rails generate redmine_plugin <plugin_name>`

执行此命令的输出为：

```shell
$ bundle exec ruby script/rails generate redmine_plugin Polls
      create  plugins/polls/app
      create  plugins/polls/app/controllers
      create  plugins/polls/app/helpers
      create  plugins/polls/app/models
      create  plugins/polls/app/views
      create  plugins/polls/db/migrate
      create  plugins/polls/lib/tasks
      create  plugins/polls/assets/images
      create  plugins/polls/assets/javascripts
      create  plugins/polls/assets/stylesheets
      create  plugins/polls/config/locales
      create  plugins/polls/test
      create  plugins/polls/README.rdoc
      create  plugins/polls/init.rb
      create  plugins/polls/config/routes.rb
      create  plugins/polls/config/locales/en.yml
      create  plugins/polls/test/test_helper.rb
```

但过程永远没有描述的这般简单。以下为具体步骤：

### 1.1 检出 redmine 工程

redmine 项目代码也托管在 github 可以直接下载 https://github.com/redmine/redmine 。

`git clone https://github.com/redmine/redmine`

### 1.2 安装 ruby

推荐使用 rubyenv 详细过程请参考 https://gorails.com/setup/osx/10.13-high-sierra 

不需要安装 sqlite

### 1.3 安装 redmine 的 gem 依赖

在 redmine 的根目录执行

`bundle install`

坑1 ：RMagick installation: Can't find MagickWand.h

RMagick 2.16.0 安装失败 

需要使用 brew 安装依赖 

`brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/6f014f2b7f1f9e618fd5c0ae9c93befea671f8be/Formula/imagemagick.rb`

`brew pin imagemagick`

请务必安装旧版本，7.x版本实测不行。

坑2: mysql2 依赖安装失败

首先需要安装 mysql 

`brew install mysql` 

这个地方很坑，会安装 mysqld 。 为了方便本地的 mysql 我使用 docker 运行了。安装好依赖后再删掉即可。 

`ld: library not found for -lssl`

这个是万恶的 xcode 问题

`xcode-select --install`

## 2. 服务器部署

部署目标为一台阿里云的 ECS 。配置 2G RAM ，单 CPU 。以前运行 ubuntu 14.04 ，且已经有 Redmine 部署。为方便部署、隔离，新的 Redmine 采用 Docker 部署。 Ubuntu 14.04 的官方源中， Docker 的最新版本为 1.6 ，无法便捷的使用 docker-compose 部署。最终的策略为借此机会将系统版本升级到 16.04.

升级之前务必检查 ECS 快照是否ok。务必检查，务必检查。

系统升级到步骤较为简单，其实每次登录时都已经提示了，只需要使用 do-release-upgrade 即可完成。在升级过程中，会提示是否更新很多软件都配置，如 sshd、apache 等。均采用保留现有配置即可。

系统升级的坑：

升级完成后，原有 Redmine 访问正常，但许多 css 文件加载出现错误。由于升级服务器是半夜进行的，鬼知道我当时在 ruby 升级的时候干了啥。幸亏我是一个有备份习惯的男人。diff 两个目录后发现静态资源文件的确在升级过程中被删除了。 一瞬间想用快照回滚然后倒回去看一下哪里点错了，想了想我的半夜时间比较值钱，直接使用备份覆盖了。

升级完成后直接安装 docker、docker-compose 一切顺利。但在 docker-compse up 时，容器并没有正常启动。查看错误信息为

```shell
standard_init_linux.go:178: exec user process caused exec format error
```

通过 Google 一通发现有人在使用 树莓派的时候遇到了同样问题，原因是平台不通导致。检查了 cpuinfo 为 intel

e 系列的 cpu 暂时先排除了 cpu 架构不同的问题。通过检查开发环境（好吧，就是一台 ubnuntu 虚拟机）与 阿里云的差别，使用 docker info，docker version 查看。最终确定开发环境为 amd64，生产为 i386 。 说起来这个其实比较尴尬，阿里云的系统以前是我选的，因为预算问题，怎么也不可能给超过 4G 内存，真的不是黑🐶。自己选的路跪着都要走完哈，找 32bit 底包。最终在 dockerhub 上发现了一个神奇的目录 i386（https://hub.docker.com/u/i386/）在这里可以找到很多常用软件的 32bit 镜像。**开源的力量是伟大的**。竟然直接就有 Redmine ！欣喜若狂！ 有现成的为啥自己写！走起。最终在新的开发环境（好吧，另一台 ubuntu 32bit 虚拟机）测试，i386 镜像 ok。

服务部署时，还遇到了 MySQL 的问题。为了节省有限的硬件资源 （2G RAM），沿用了宿主机原有的 MySQL 数据库，而没有重新部署 MySQL 容器。好吧，我承认，没有在 i386 下找到 MySQL 镜像。为了部分安全性，MySQL 服务默认只监听了 127.0.0.1 地址。容器与宿主机之间的通信需要通过 docker0 网桥进行。所以 MySQL 需要监听所有地址 0.0.0.0 。修改 mysqld.cnf 中的 bind-address 即可。

最后，需要创建 host 为 % 的用户。当然我肯定会不记得 root 密码的。好在 debian.cnf 中记录了 debian-sys-maint 的登录信息，可以不用停机就修改密码。当然有这个超级用户的登录信息，可以任意创建用户、数据库并赋权了。

最终一条命令把容器拉起来：

```shell
docker run -d  -p 8888:3000 -v /var/redmine/files:/usr/src/redmine/files -v /var/redmine/plugins:/usr/src/redmine/plugins -v  /etc/localtime:/etc/localtime -e REDMINE_DB_MYSQL='xxx.xxx.xx.x' -e REDMINE_DB_PORT=3306 -e REDMINE_DB_DATABASE=redmine3 -e REDMINE_DB_USERNAME=redmine3 -e REDMINE_DB_PASSWORD='nevertellu' i386/redmine
```

此处，将 redmine 中的 files、plugins 目录都外挂主机目录，方便数据留存与插件安装。



## 参考

坑1 https://stackoverflow.com/questions/39494672/rmagick-installation-cant-find-magickwand-h

坑2 https://github.com/brianmario/mysql2/issues/795

镜像平台错误 https://github.com/ethereum/go-ethereum/issues/3775

mysql debian.cnf https://serverfault.com/questions/9948/what-is-the-debian-sys-maint-mysql-user-and-more

I386/redmine https://hub.docker.com/r/i386/redmine/

