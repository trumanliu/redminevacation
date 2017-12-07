# ingeek vacation plugin

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







## 参考

坑1 https://stackoverflow.com/questions/39494672/rmagick-installation-cant-find-magickwand-h

坑2 https://github.com/brianmario/mysql2/issues/795

