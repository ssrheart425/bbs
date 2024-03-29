# BBS博客园项目

## BBS表设计

```python
1. 用户表 继承AbstractUser
	扩展
    phone         电话号码
    avatar        用户头像
	is_deleted    是否删除
    create_time   创建时间
    
    外键字段
   		一对一个人站点表
    
    
2. 个人站点表
	site_time     站点名称
    site_title    站点标题
    site_theme    站点样式

    
3. 文章标签表
	name          标签名
    
    外键字段
    	一对多个人站点
    
4. 文章分类表
	name          分类名
    
    外键字段
    	一对多个人站点

5. 文章表
	title         文章标题
    desc          文章简介
    content       文章内容
    create_time   发布时间
	
    数据库字段设计优化
    (虽然下述的三个字段可以从其他表里面跨表查询计算得出，但是效率很低)
    up_num        点赞数
    down_num      点踩数
    comment_num   评论数
    
    外键字段
    	一对多个人站点
        多对多文章标签表
    	一对多文章分类
    
6. 点赞点踩表 (记录哪个用户给哪篇文章点了赞还是点了踩)
	user          用户		ForeignKey(to="User")
    article       文章		ForeignKey(to="Article")
    is_up         点赞点踩     BooleanField()

7. 文章评论表 (记录哪个用户给哪篇文章写了哪些评论内容)
	user          用户		ForeignKey(to="User")
    article       文章		ForeignKey(to="Article")
    content       评论		CharField()
    comment_time  评论时间	   DateField()
    # ORM专门提供的自关联写法
    parent                    ForeignKey(to="self",null=True)

根评论和子评论的概念
	根评论就是直接评论当前发布的内容的
    子评论是评论别人的评论
    
    根评论与子评论是一对多的关系 外键字段建在子评论里
```

- user/models

```python
from django.db import models


from django.contrib.auth.models import AbstractUser

class UserInfo(AbstractUser):
    phone = models.CharField(max_length=11, verbose_name='手机号', help_text='这是手机号', null=True)
    # 给avatar字段传文件对象 该文件会自动存储到avatar文件下 然后avatar字段只保存文件路径avatar/default.jpg
    avatar = models.FileField(upload_to='avatar/', verbose_name='用户头像', help_text='这是用户头像',
                              default='avatar/default.png')
    is_deleted = models.BooleanField(verbose_name="是否删除", help_text="是否已删除", default=False)
    create_time = models.DateField(auto_now_add=True, verbose_name='创建时间', help_text='这是创建时间')

    blog = models.OneToOneField(to='blog.Blog', null=True, blank=True, on_delete=models.CASCADE)
```

- blog/models

```python
from django.db import models

from django.contrib.auth.models import AbstractUser


class Blog(models.Model):
    site_name = models.CharField(max_length=32, verbose_name='站点名称', help_text='这是站点名称')
    site_title = models.CharField(max_length=32, verbose_name='站点标题', help_text='这是站点标题')
    site_theme = models.CharField(max_length=64, verbose_name='站点样式', help_text='这是站点样式')
    def __str__(self):
        return self.site_name

class Adv(models.Model):
    title = models.CharField(max_length=64, verbose_name='广告标题', help_text='这是广告标题')
    content = models.TextField(verbose_name='广告内容', help_text='这是广告内容')
    create_time = models.DateTimeField(auto_now=True, verbose_name='创建时间', help_text='这是创建时间')
    update_time = models.DateTimeField(auto_now_add=True, verbose_name='更新时间', help_text='这是更新时间')
    mobile = models.CharField(max_length=11, verbose_name='手机号', help_text='这是手机号', default='', blank=True)
    img = models.FileField(upload_to='advImg/', verbose_name='广告图片', help_text='这是广告图片', default='advImg/kaixin.png')
    is_background_img = models.BooleanField(default=False, verbose_name='是否为背景图', help_text='这是是否为背景图')
```

- article/models

```python
from django.db import models


class Category(models.Model):
    name = models.CharField(max_length=32, verbose_name='文章分类', help_text='这是文章分类')
    blog = models.ForeignKey(to='blog.Blog', on_delete=models.CASCADE, null=True)

    def __str__(self):
        return self.name


class Tag(models.Model):
    name = models.CharField(max_length=32, verbose_name='文章标签', help_text='这是文章标签')
    blog = models.ForeignKey(to='blog.Blog', on_delete=models.CASCADE, null=True)

    def __str__(self):
        return self.name


class Article(models.Model):
    title = models.CharField(max_length=64, verbose_name='文章标题', help_text='这是文章标题')
    desc = models.CharField(max_length=255, verbose_name='文章简介', help_text='这是文章简介')
    content = models.TextField(verbose_name='文章内容', help_text='这是文章内容')
    create_time = models.DateField(auto_now_add=True, verbose_name='创建时间', help_text='这是创建时间')

    up_num = models.BigIntegerField(default=0, verbose_name='点赞数', help_text='这是点赞数')
    up_down = models.BigIntegerField(default=0, verbose_name='点踩数', help_text='这是点踩数')
    comment_num = models.BigIntegerField(default=0, verbose_name='评论数', help_text='这是评论数')

    blog = models.ForeignKey(to='blog.Blog', on_delete=models.CASCADE, null=True)
    category = models.ForeignKey(to='Category', on_delete=models.CASCADE, null=True)
    tags = models.ManyToManyField(to='Tag', through='Article2Tag', through_fields=('article', 'tag'))

    def __str__(self):
        return self.title


class Article2Tag(models.Model):
    article = models.ForeignKey(to='Article', on_delete=models.CASCADE)
    tag = models.ForeignKey(to='Tag', on_delete=models.CASCADE)


class UpAndDown(models.Model):
    user = models.ForeignKey(to='user.UserInfo', on_delete=models.CASCADE)
    article = models.ForeignKey(to='Article', on_delete=models.CASCADE)
    is_up = models.BooleanField(verbose_name='是否点赞', help_text='这是是否点赞')


class Comment(models.Model):
    user = models.ForeignKey(to='user.UserInfo', on_delete=models.CASCADE)
    article = models.ForeignKey(to='Article', on_delete=models.CASCADE)
    content = models.CharField(max_length=255, verbose_name='评论内容', help_text='这是评论内容')
    comment_time = models.DateTimeField(auto_now_add=True, verbose_name='评论时间', help_text='这是评论时间')
    parent = models.ForeignKey(to='self', on_delete=models.CASCADE, null=True, blank=True, verbose_name='父评论',
                               help_text='这是父评论')
```

## 前期配置

- settings

```python
BASE_DIR = Path(__file__).resolve().parent.parent

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'user',
    'blog',
    'article'
]

# 给每个
TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates',
                 os.path.join('user','templates'),
                 os.path.join('blog','templates'),
                 os.path.join('article','templates'),
                 ]
        ,
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

# 用mysql数据库
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'bbs01',
        'USER': 'root',
        'PASSWORD': '123456',
        'PORT': 3306,
        'HOST': '127.0.0.1',
        'CHARSET': 'utf8mb4',
    }
}

# 汉化
LANGUAGE_CODE = 'zh-hans'
TIME_ZONE = 'Asia/Shanghai'

# 给每个static都配置
STATICFILES_DIRS = [
    os.path.join(BASE_DIR, "static"),
]

# 把django自带的表换成自己的
AUTH_USER_MODEL = 'user.UserInfo'
```

- urls 路由分发

```python
from django.contrib import admin
from django.urls import path, include, re_path
from user import urls as user_urls
from blog import urls as blog_urls
from article import urls as article_urls
from backend import urls as backend_urls
from article.views import article_detail
from blog import views as blog_index_views
from BBS01 import settings
from django.views.static import serve
from article.views import site
urlpatterns = [
    path('admin/', admin.site.urls, name='admin'),
    path('', blog_index_views.index, name='index'),
    path('user/', include(user_urls)),
    path('blog/', include(blog_urls)),
    path('article/', include(article_urls)),
    path('backend/', include(backend_urls)),

    path('<slug:username>/article/<int:pk>/', article_detail,name='article_detail'),
    re_path('media/(?P<path>.*)', serve, {'document_root': settings.MEDIA_ROOT}),
    path('<slug:username>/', site, name='site'),
    re_path(r"^(?P<username>\w+)/(?P<condition>category|tag|archive)/(?P<param>.*)/$", site, name="article_left"),
]
```

- 给pymysql打猴子补丁

```python
import pymysql
pymysql.install_as_MySQLdb()
```

- html引入js/css

```python
<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/3.4.1/js/bootstrap.min.js"></script>

<link rel="stylesheet" href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/3.4.1/css/bootstrap.min.css">
```

# user 用户功能

## 路由配置

```python
urlpatterns = [
    path('register/',views.register, name='register'),
    path('login/',views.login, name='login'),
    path('get_code/',views.get_code, name='get_code'),
    path('logout/', views.logout, name='logout'),
]
```

## 注册功能

- views

```python
from django.http import JsonResponse
from django.shortcuts import render
from user.MyForms import MyRegForm
from user import models


def register(request):
    form_obj = MyRegForm()  # 实例化一个form对象

    if request.method == 'POST':
        back_dic = {'code': 1000, 'msg': ''}
        # 校验数据是否合法
        form_obj = MyRegForm(request.POST)
        if form_obj.is_valid():
            # 校验通过后的数据
            # print(form_obj.cleaned_data)
            clean_data = form_obj.cleaned_data
            clean_data.pop('confirm_password')
            # 用户头像
            file_obj = request.FILES.get('avatar')
            # 这个地方一定要判断用户是否上传了头像
            if file_obj:
                clean_data['avatar'] = file_obj
            models.UserInfo.objects.create_user(**clean_data)
            back_dic['url'] = '/login/'
        else:
            back_dic['code'] = 2000
            back_dic['msg'] = form_obj.errors
        return JsonResponse(back_dic)
    return render(request, 'register.html', locals())  # 返回一个html页面
```

- Forms组件

```python
# -*- coding: utf-8 -*-
# author : heart
# blog_url : https://www.cnblogs.com/ssrheart/
# time : 2024/3/13
from django import forms
from user import models

class MyRegForm(forms.Form):
    username = forms.CharField(label='用户名', max_length=8,
                               min_length=3,
                               error_messages={
                                   'required': '用户名不能为空',
                                   'max_length': '用户名最长8位',
                                   'min_length': '用户名最短3位',
                               },
                               widget=forms.widgets.TextInput(attrs={'class': 'form-control'})
                               )
    password = forms.CharField(label='密码', max_length=8,
                               min_length=3,
                               error_messages={
                                   'required': '密码不能为空',
                                   'max_length': '密码最长8位',
                                   'min_length': '密码最短3位',
                               },
                               widget=forms.widgets.PasswordInput(attrs={'class': 'form-control'})
                               )
    confirm_password = forms.CharField(label='确认密码', max_length=8,
                                       min_length=3,
                                       error_messages={
                                           'required': '确认密码不能为空',
                                           'max_length': '确认密码最长8位',
                                           'min_length': '确认密码最短3位',
                                       },
                                       widget=forms.widgets.PasswordInput(attrs={'class': 'form-control'})
                                       )
    email = forms.EmailField(label='邮箱',
                             error_messages={
                                 'required': '邮箱不能为空',
                                 'invalid': '邮箱格式错误',
                             },
                             widget=forms.widgets.EmailInput(attrs={'class': 'form-control'})
                             )

    # 钩子函数
    # 局部钩子
    def clean_username(self):
        username = self.cleaned_data.get('username')
        is_exist = models.UserInfo.objects.filter(username=username)
        if is_exist:
            self.add_error('username', '用户名已存在')
        return username

    # 全局钩子
    def clean(self):
        password = self.cleaned_data.get('password')
        confirm_password = self.cleaned_data.get('confirm_password')
        if password != confirm_password:
            self.add_error('confirm_password', '两次密码不一致')
        return self.cleaned_data
```

- html

```html
<!-- -*- coding: utf-8 -*- -->
<!-- author : heart -->
<!-- blog_url : https://www.cnblogs.com/ssrheart/ -->
<!-- time : 2024/3/13 -->
{% load static %}
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script src="{% static 'js/bootstrap.min.js' %}"></script>
    <script src="{% static 'js/jquery.min.js' %}"></script>
    <link rel="stylesheet" href="{% static 'css/bootstrap.min.css' %}">
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-8 col-md-offset-2">
            <h1 class="text"> 注册 </h1>
            <form id="myform">
                {% csrf_token %}
                {% for form in form_obj %}
                    <div class="form-group">
                        <label for="{{ form.auto_id }}">{{ form.label }}</label>
                        {{ form }}
                        <span style="color: red"></span>
                    </div>
                {% endfor %}
                <div class="form-group">
                    <label for="myfile">头像
                        {% load static %}
                        <img src="{% static 'img/default.png' %}" alt=""
                             style="width: 80px;height: 80px;margin-left: 20px;border-radius: 50%;" id="myimg"></label>
                    <input type="file" id="myfile" name="avatar" style="display: none">
                </div>
                <input type="button" class="btn btn-primary pull-right btn-block" value="注册" id="id_commit">
            </form>
        </div>
    </div>
</div>
</body>
<script>
    $('#myfile').change(function () {
        // 文件阅读器对象
        // 1 先生成一个文件阅读器对象
        let myFileReader = new FileReader();
        // 2 获取用户上传的头像文件
        let fileobj = $(this)[0].files[0];
        // 3 将文件对象交给阅读器读取
        myFileReader.readAsDataURL(fileobj); // 异步操作 IO操作
        // 4 当文件阅读器读取完毕后，将读取到的文件内容赋值给img标签
        myFileReader.onload = function () {
            $('#myimg').attr('src', myFileReader.result);
        }
    })
    $('#id_commit').click(function () {
        let formData = new FormData();
        $.each($('#myform').serializeArray(), function (index, obj) {
            console.log(index, obj);
            formData.append(obj.name, obj.value);

        })
        formData.append('avatar', $('#myfile')[0].files[0]);

        $.ajax({
            url: '',
            type: 'post',
            data: formData,
            processData: false,
            contentType: false,
            success: function (args) {
                if (args.code == 1000) {
                    // 跳转到登录页面
                    window.location.href = args.url
                } else {
                    $.each(args.msg, function (index, obj) {
                        // console.log(index,obj) // username ['用户名不能为空']
                        let targetId = '#id_' + index
                        $(targetId).next().text(obj[0]).parent().addClass('has-error')
                    })
                }
            }
        })
        // 给所有的input框绑定获取焦点事件
        $('input').focus(function (){
            // 将input下面的span标签和input外面的div标签修改内容及属性
            $(this).next().text('').parent().removeClass('has-error')
        })
    })
</script>

</html>
```

![image-20240315145616526](https://github.com/ssrheart425/bbs/assets/111131332/aed179fb-c977-4581-ae1a-1be515c93cac)


> 提供的代码实现了Django中的用户注册功能，包括表单验证、客户端交互和服务器端处理。
>
> 以下是注册功能的流程总结：
>
> 1. **URL映射**：
>    - 在项目user的`urls.py`文件中有一个URL模式映射到`register`函数。这个URL模式指向视图中的`register`函数。
>
> 2. **视图函数 (`register`) 分析**：
>    - `register`函数处理GET和POST请求。
>    - 当接收到GET请求时，它渲染 'register.html' 模板以及表单。
>    - 当接收到POST请求时，它处理表单数据。
>    - 如果表单数据有效，则使用提供的数据创建新用户。
>    - 如果表单数据无效，则返回适当的错误消息。
>
> 3. **表单验证 (`MyRegForm`)**：
>    - `MyRegForm`是一个Django表单类，用于处理用户注册。
>    - 它定义了用户名、密码、确认密码和电子邮件字段。
>    - 它指定了字段约束，如最小和最大长度，并提供了验证失败的错误消息。
>    - 它包括本地和全局表单验证钩子（`clean_username`和`clean`），用于检查用户名唯一性和密码确认。
>
> 4. **HTML模板 (`register.html`) 分析**：
>    - HTML模板包括一个用户注册表单。
>    - 它对表单字段进行迭代，并渲染它们以及相应的标签和输入元素。
>    - 它包括一个文件输入字段，用于用户的头像选择。
>    - 包含JavaScript代码以处理头像文件选择和通过AJAX提交表单。
>
> 5. **JavaScript功能**：
>    - JavaScript代码处理文件输入变化事件，以显示所选头像的预览。
>    - 当用户提交注册表单时，它通过AJAX序列化表单数据并将其提交。
>    - 在成功注册时，用户将被重定向到登录页面。
>    - 如果由于验证错误而注册失败，则错误消息将在相应字段旁边显示。
>
> 6. **流程总结**：
>    - 用户通过相应的URL访问注册页面。
>    - 显示注册表单。
>    - 用户填写注册详情，包括选择头像图片。
>    - 提交表单后，客户端JavaScript捕获表单数据，并将其异步发送到服务器。
>    - 服务器端的Django视图验证表单数据。
>    - 如果验证通过，则创建新的用户账户，并将用户重定向到登录页面。
>    - 如果验证失败，则错误消息返回客户端，并重新渲染表单，显示相应字段旁边的错误消息。

## 登录功能

### (1)验证码

- 验证码推导一

```python
def get_code(request):
    # 方式一：直接获取后端现成的二进制图片二进制数据发送给前端
    with open('user/static/img/1.jpg', 'rb') as f:
        data = f.read()
    return HttpResponse(data)  # 返回一个图片
```

- 验证码推导二
- 文件存储繁琐 IO操作效率低
- 需要用到相关模块 `Pillow`

```python
from PIL import Image, ImageDraw, ImageFont
'''
Image : 生成图片
ImageDraw : 能够在图片上乱涂乱画
ImageFont : 控制字体样式
'''
```

```python
import random
def get_random():
    return random.randint(0,255),random.randint(0,255),random.randint(0,255)

def get_code(request):
    # 方式二：利用pillow模块动态生成图片
    # img_obj = Image.new('RGB',(430,35),'red') # 可以指定颜色
    # img_obj = Image.new('RGB',(430,35),(255,255,255)) # 还可以放rbg参数
    img_obj = Image.new('RGB',(430,35),get_random()) # 随机颜色
    # 将图片对象保存起来
    with open('xxx.png','wb')as f:
        img_obj.save(f,'png')
    with open('xxx.png','rb')as f:
        data = f.read()
    return HttpResponse(data)  # 返回一个图片
```

![image-20240315151124680](https://github.com/ssrheart425/bbs/assets/111131332/629ada39-1162-454f-b1fd-daef62b88ca5)


- 验证码推导三
- 需要用到相关模块 `io`

```python
from io import BytesIO,StringIO
"""
内存管理器模块
BytesIO : 临时保存数据 返回的时候数据是二进制
StringIO : 临时保存数据 返回的时候数据是字符串
"""
```

```python
import random
def get_random():
    return random.randint(0,255),random.randint(0,255),random.randint(0,255)

def get_code(request):
    # 方式三：利用io模块将图片保存在内存中
    img_obj = Image.new('RGB', (430, 35), get_random())
    # 先生成一个内存管理器对象 可以看成是文件聚柄
    io_obj = BytesIO()
    img_obj.save(io_obj, 'png')
    return HttpResponse(io_obj.getvalue())  # 从内存管理器中读取二进制的图片数据返回给前端
```

- 验证码最终步骤四
- 写图片验证码

```python
from PIL import Image, ImageDraw, ImageFont
from io import BytesIO, StringIO
import random
def get_random():
    return random.randint(0,255),random.randint(0,255),random.randint(0,255)

def get_code(request):
    # 方式四：动态生成验证码图片
    img_obj = Image.new('RGB', (430, 35), get_random())
    img_draw = ImageDraw.Draw(img_obj)  # 产生一个画笔对象
    img_font = ImageFont.truetype('static/font/春联标准行书体.ttf', 30)

    # 随机验证码 五位数的随机验证码 数字 小写字母 大写字母
    code = ''
    for i in range(5):
        random_num = str(random.randint(0, 9))
        random_lower = chr(random.randint(97, 122))
        random_upper = chr(random.randint(65, 90))
        # 从上面三个随机选一个
        random_choice = random.choice([random_num, random_lower, random_upper])
        # 将产生的随机字符串写到图片上
        img_draw.text((i * 60 +60, 0), random_choice, get_random(), img_font)
        code += random_choice
    print(code)
    # 随机验证码在登录的视图函数里面要用到 要比对 所以要存到session中
    request.session['code'] = code
    io_obj = BytesIO()
    img_obj.save(io_obj, 'png')
    return HttpResponse(io_obj.getvalue())  # 从内存管理器中读取二进制的图片数据返回给前端
```

```html
<img src="/user/get_code/" alt="" style="width: 487px;height: 30px" id="id_img">
<script>
    $('#id_img').click(function (){
        // 获取标签之前的src属性
        let oldVal = $(this).attr('src');
        $(this).attr('src',oldVal += '?')
    })
</script>
```

![image-20240315154104125](https://github.com/ssrheart425/bbs/assets/111131332/8d9ccb8f-1d4d-4421-bbad-f51ba7457e61)


### (2)登录功能

```python
import random
from PIL import Image, ImageDraw, ImageFont
from io import BytesIO, StringIO
from django.http import JsonResponse, HttpResponse
from django.shortcuts import render
from user.MyForms import MyRegForm
from user import models
from django.contrib import auth

def login(request):
    if request.method == 'POST':
        back_dict = {'code': 1000, 'msg': ''}
        data = request.POST
        username = data.get('username')
        password = data.get('password')
        code = data.get('code')
        # 校验验证码
        if request.session.get('code').upper() == code.upper():
            # 校验用户名和密码
            user_obj = auth.authenticate(request, username=username, password=password)
            if user_obj:
                auth.login(request, user_obj)
                back_dict['url'] = '/blog/index/'
            else:
                back_dict['code'] = 2000
                back_dict['msg'] = '用户名或密码错误'
        else:
            back_dict['code'] = 3000
            back_dict['msg'] = '验证码错误'
        return JsonResponse(back_dict)

    return render(request, 'login.html',locals())

def get_random():
    return random.randint(0, 255), random.randint(0, 255), random.randint(0, 255)

def get_code(request):
    # 方式四：动态生成验证码图片
    img_obj = Image.new('RGB', (430, 35), get_random())
    img_draw = ImageDraw.Draw(img_obj)  # 产生一个画笔对象
    img_font = ImageFont.truetype('static/font/春联标准行书体.ttf', 30)

    # 随机验证码 五位数的随机验证码 数字 小写字母 大写字母
    code = ''
    for i in range(5):
        random_num = str(random.randint(0, 9))
        random_lower = chr(random.randint(97, 122))
        random_upper = chr(random.randint(65, 90))
        # 从上面三个随机选一个
        random_choice = random.choice([random_num, random_lower, random_upper])
        # 将产生的随机字符串写到图片上
        img_draw.text((i * 60 + 60, 0), random_choice, get_random(), img_font)
        code += random_choice
    print(code)
    # 随机验证码在登录的视图函数里面要用到 要比对 所以要存到session中
    request.session['code'] = code
    io_obj = BytesIO()
    img_obj.save(io_obj, 'png')
    return HttpResponse(io_obj.getvalue())  # 从内存管理器中读取二进制的图片数据返回给前端
```

```html
<!-- -*- coding: utf-8 -*- -->
<!-- author : heart -->
<!-- blog_url : https://www.cnblogs.com/ssrheart/ -->
<!-- time : 2024/3/14 -->
{% load static %}
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>登录</title>
    <script src="{% static 'js/bootstrap.min.js' %}"></script>
    <script src="{% static 'js/jquery.min.js' %}"></script>
    <link rel="stylesheet" href="{% static 'css/bootstrap.min.css' %}">
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-8 col-md-offset-2">
            <form id="login_form">
                {% csrf_token %}
                <h1 class="text-center">登陆页面</h1>
                <div class="form-group">
                    <label for="username">用户名</label>
                    <input type="text" name="username" id="username" class="form-control">
                </div>
                <div class="form-group">
                    <label for="password">密码</label>
                    <input type="password" name="password" id="password" class="form-control">
                </div>
                <div class="form-group">
                    <label for="id_code">验证码</label>
                    <div class="row">
                        <div class="col-md-6">
                            <input type="text" name="code" id="id_code" class="form-control">
                        </div>
                        <div class="col-md-6">
                            <img src="/user/get_code/" alt="" style="width: 487px;height: 30px" id="id_img">
                        </div>
                    </div>
                </div>
                <input type="button" class="btn btn-primary" value="登录" id="id_tijiao">
                <span style="color:red" id='error'></span>
            </form>
        </div>
    </div>
</div>

</body>
<script>
    $('#id_img').click(function () {
        // 获取标签之前的src属性
        let oldVal = $(this).attr('src');
        $(this).attr('src', oldVal += '?')
    })
    $('#id_tijiao').click(function () {
        let data = {}
        $.each($('#login_form').serializeArray(), (index, dataDict) => {
            data[dataDict.name] = dataDict.value
        })
        $.ajax({
            url: '',
            type: 'post',
            data: data,
            success: function (args) {
                if (args.code === 1000) {
                    // 直接跳转到首页
                    window.location.href = args.url
                } else {
                    // 渲染错误信息
                    $('#error').text(args.msg)
                }
            }
        })
    })
</script>
</html>
```

## 注销功能

`request.session.flush()`

```python
def logout(request):
    if request.method == 'POST':
        request.session.flush()
        return render(request, 'login.html', locals())
    return render(request, 'login.html', locals())
```

```js
<script>
    $(document).ready(function () {
        // 监听点击事件
        $('#ajax-link').click(function (e) {
            e.preventDefault();  // 阻止默认的导航行为
            let data = {};
            $.each($('#login_form').serializeArray(), function (index, dataDict) {
                data[dataDict.name] = dataDict.value;
            });
            swal({
                title: "确定要退出登录吗？",
                icon: "warning",
                buttons: ['取消', '确定'],
                dangerMode: true,
            })
                .then((willDelete) => {
                    if (willDelete) {
                        $.ajax({
                            url: '/user/logout/',  // 修改为退出登录的 URL
                            type: 'POST',     // 使用 POST 请求
                            data: data,
                            success: function (data) {
                                swal("用户已退出!", {
                                    icon: "success",
                                }).then(() => {
                                    // 退出成功后刷新页面
                                    location.reload();
                                });
                            }
                        });
                    }
                });
        });
    });
</script>
```

## 修改密码

- py文件

```python
@login_required
def change_password(request):
    back_dict = {'code': 1000, 'msg': '修改密码成功!'}
    if request.is_ajax():
        if request.method == 'POST':
            data = request.POST
            old_password = data.get('old_password')
            new_password = data.get('new_password')
            confirm_password = data.get('confirm_password')
            print(data)
            if request.user.check_password(old_password):
                if old_password == new_password:
                    back_dict['code'] = 1004
                    back_dict['msg'] = '新密码不能与原密码相同'
                    return JsonResponse(back_dict)
                if new_password == confirm_password:
                    request.user.set_password(new_password)
                    request.user.save()
                    back_dict['url'] = '/user/login/'
                    return JsonResponse(back_dict)
                else:
                    back_dict['code'] = 1001
                    back_dict['msg'] = '两次密码不一致'
                    return JsonResponse(back_dict)
            else:
                back_dict['code'] = 1002
                back_dict['msg'] = '原密码错误'
                return JsonResponse(back_dict)
    else:
        return redirect('login')
```

- html

```html
<li><a href="#changePasswordModal" data-toggle="modal">修改密码</a></li>
<div class="modal fade" id='changePasswordModal' tabindex="-1" role="dialog"
     aria-labelledby="changePasswordModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">修改密码</h4>
            </div>
            <div class="modal-body">
                <form id="password_edit">
                    {% csrf_token %}
                    <div class="text-center">
                        <label for="username">用户名</label>
                        <p><input type="text" disabled value="{{ request.user.username }}"
                                  class="form-control" style="text-align: center;"
                                  id="username" name="username"></p>
                    </div>
                    <div class="text-center">
                        <label for="old_password">旧密码</label>
                        <p><input type="text" class="form-control"
                                  style="text-align: center;"
                                  id="old_password" name="old_password"></p>
                    </div>
                    <div class="text-center">
                        <label for="new_password">新密码</label>
                        <p><input type="text" class="form-control"
                                  style="text-align: center;"
                                  id="new_password" name="new_password"></p>
                    </div>
                    <div class="text-center">
                        <label for="confirm_password">确认密码</label>
                        <p><input type="text" class="form-control"
                                  style="text-align: center;"
                                  id="confirm_password" name="confirm_password"></p>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消
                </button>
                <button type="button" class="btn btn-primary" id="password_edit1">确定
                </button>
            </div>
        </div>
    </div>
</div>

```

- js

```js
<script>
    $('#password_edit1').click(function () {
        let data = {};
        $.each($('#login_form').serializeArray(), function (index, dataDict) {
            data[dataDict.name] = dataDict.value;
        });
        $.ajax({
            url: '/blog/change_password/',
            type: 'post',
            data: data,
            success: function (response) {
                if (response.code == 1000) {
                    swal({
                        title: response.msg,
                        icon: "success",
                        button: true,
                    }).then(() => {
                        window.location.href = response.url;
                    });
                } else {
                    swal({
                        title: response.msg,
                        icon: "error",
                        button: true,
                    }).then(() => {
                        window.location.reload();
                    });
                }
            }
        })
    })
</script>
```

## 修改头像

- 点击页面上的头像跳出模态框，上传文件修改

- py

```python
def index(request):
    avatar_obj = UserInfo.objects.filter(username=request.user).values(
        'avatar'
    )
    if request.method == 'POST' and request.is_ajax():
        data = request.POST
        avatar = request.FILES.get('avatar')
        if avatar:
            res = UserInfo.objects.filter(username=request.user).first()
            res.avatar = avatar
            res.save()
            return JsonResponse({'code': 200, 'msg': '头像上传成功'})

        return render(request, 'index.html', locals())
```

- html

```html
<div class="modal fade modal_img" tabindex="-1" role="dialog" id='myModal'>
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title text-center">修改头像</h4>
            </div>
            <div class="modal-body">
                {% csrf_token %}
                <div class="form-group text-center">
                    <label for="myfile">头像
                        {% for avatar in avatar_obj %}
                        <img src="/media/{{ avatar.avatar }}/" alt=""
                             style="width: 80px;height: 80px;margin-left: 20px;border-radius: 50%;"
                             id="myimg"></label>
                    <input type="file" id="myfile" name="avatar" style="display: none">
                    {% endfor %}
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                </button>
                <button type="button" class="btn btn-primary" id="submit_avatar">提交</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
```

- js

```js
<script>
    $('#myfile').change(function () {
        // 创建文件阅读器对象
        let myFileReader = new FileReader();
        // 获取用户上传的头像文件
        let fileobj = $(this)[0].files[0];
        // 将文件对象交给阅读器读取
        myFileReader.readAsDataURL(fileobj); // 异步操作 IO操作
        // 当文件阅读器读取完毕后，将读取到的文件内容赋值给img标签
        myFileReader.onload = function () {
            $('#myimg').attr('src', myFileReader.result);
        }
    })

    $('#submit_avatar').click(function () {
        let formData = new FormData();
        formData.append('avatar', $('#myfile')[0].files[0]);
        formData.append('csrfmiddlewaretoken', '{{ csrf_token }}'); // 将 CSRF 令牌添加到表单数据
        $.ajax({
            url: '', // 设置上传文件的URL，你需要将其替换为实际的服务器端处理URL
            type: 'post', // 使用 POST 方法上传文件
            data: formData, // 使用 FormData 对象传递文件数据
            contentType: false, // 不设置 contentType，让浏览器自动识别
            processData: false, // 不对数据进行序列化处理
            success: function (response) {
                if (response.code == 200) {
                    swal({
                        title: response.msg,
                        icon: "success",
                        button: true,
                    }).then(() => {
                        window.location.reload()
                    });
                }
            }
        })
    })
</script>
```

![image-20240329092142778](https://github.com/ssrheart425/bbs/assets/111131332/34dfe748-373f-4329-aa55-a2fdfcd9ec08)


# blog 首页

## 路由配置

```python
from django.urls import path
from blog import views
urlpatterns = [
    path('index/', views.index, name='index'),
    path('change_password/', views.change_password, name='change_password'),
    path('adv/', views.adv, name='adv'),
    path('edit_adv/', views.edit_adv, name='edit_adv'),
]
```

## 百度搜索功能添加

```html
<script>
    $(document).ready(
        $('#baidu_btn').click(function (event) {
            function search() {
                let keyword = $('#search_key').val();
                let newurl = 'https://www.baidu.com/s?wd=' + keyword;
                window.open(newurl, '_blank')
            }

            event.preventDefault();
            search();

        }),
    )
</script>
```

![image-20240319193744483](https://github.com/ssrheart425/bbs/assets/111131332/986561ee-60c9-422c-913b-1ea9439b2664)


## 广告中心(添加、编辑、删除)

- 添加、删除

```python
import os.path
from django.http import JsonResponse
from django.shortcuts import render, HttpResponse, redirect
from django.contrib.auth.decorators import login_required
from blog import models
from blog.fenyeqi import Pagination
from article import models as article_models
from user.models import UserInfo

def adv(request):
    adv_data = models.Adv.objects.all()
    current_page = request.GET.get("page", 1)
    all_count = adv_data.count()
    page_obj = Pagination(current_page=current_page, all_count=all_count, per_page_num=5)
    page_queryset = adv_data[page_obj.start:page_obj.end]
    cebian_gg = models.Adv.objects.all()[:3]
    avatar_obj = UserInfo.objects.filter(username=request.user).values(
        'avatar'
    )
    if request.is_ajax():
        back_dic = {'code': 2000, 'msg': '', 'url': ''}
        data = request.POST
        title = data.get('title')
        content = data.get('content')
        phone = data.get('phone')
        lunbo = data.get('lunbo')
        adv_img = request.FILES.get('adv_img')
        delete = data.get('delete')
        action = data.get('action')
        if action == 'del':
            models.Adv.objects.filter(id=delete).delete()
        if not adv_img:
            adv_img = 'advImg/kaixin.png'
        if not all([title, content, phone, lunbo]):
            back_dic['code'] = 2001
            back_dic['msg'] = '请补齐参数!'
            return JsonResponse(back_dic)
        models.Adv.objects.create(title=title, content=content, mobile=phone, img=adv_img, is_background_img=int(lunbo))
        back_dic['code'] = 2000
        back_dic['msg'] = '添加广告成功!'
        back_dic['url'] = '/blog/adv/'
        return JsonResponse(back_dic)
    return render(request, 'detail.html', locals())

```

```html
<input type="submit" class="btn btn-danger" value="添加广告" id="gg_model" data-toggle="modal"
       data-target="#myModal">
<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                                                                                                  aria-hidden="true">&times;</span></button>
                <h4 class="modal-title text-center" id="myModalLabel">添加广告信息</h4>
            </div>
            <div class="modal-body">
                <form action="" id="myform">
                    {% csrf_token %}
                    <div class="text-center">
                        <label for="title">广告标题</label>
                        <p><input type="text" class="form-control text-center" id="title" name="title"></p>
                    </div>
                    <div class="text-center">
                        <label for="content">广告内容</label>
                        <p><input type="text" class="form-control text-center" id="content" name="content"></p>
                    </div>
                    <div class="text-center">
                        <label for="phone">手机号</label>
                        <p><input type="text" class="form-control text-center" id="phone" name="phone"></p>
                    </div>
                    <br>
                    <div class="text-center">
                        <label for="myfile">图片<img src="{% static 'img/kaixin.png' %}" alt="img_check"
                                                   style="height: 80px;width: 80px" id="myimg">
                        </label>
                        <p><input type="file" id="myfile" name="img" style="display: None"></p>
                    </div>
                    <div class="text-center">
                        <label for="lunbo">是否轮播图</label>
                        <input type="radio" name="lunbo" value="1">是
                        <input type="radio" name="lunbo" value="0" checked>否
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="adv_edit">提交</button>
            </div>
        </div>
    </div>
</div>
```

![image-20240319193825187](https://github.com/ssrheart425/bbs/assets/111131332/05b84173-ca31-41de-b650-d274279701f3)


![image-20240319193836038](https://github.com/ssrheart425/bbs/assets/111131332/e61b4431-c0b9-468d-a7e9-0663fa7cccc5)


- 编辑广告

```python
def edit_adv(request):
    back_dic = {'code': 2000, 'msg': '修改成功!', 'url': ''}
    if request.is_ajax():
        data = request.POST
        advtitle = data.get('advtitle')
        advcontent = data.get('advcontent')
        advphone = data.get('advphone')
        advlunbo = data.get('advlunbo')
        adv_img = request.FILES.get('advedit_img')
        adv_id = data.get('adv_id')
        if not adv_img:
            back_dic['code'] = 2002
            back_dic['msg'] = '图片必须修改!'
            return JsonResponse(back_dic)
        else:
            path = os.path.dirname(os.path.dirname(__file__)) + '/media' + "/advImg/" + adv_img.name
            with open(path, 'wb') as f:
                for i in adv_img.chunks():
                    f.write(i)
            adv_img = "adVimg/" + str(adv_img)
        if not all([advtitle, advcontent, advphone, advlunbo]):
            back_dic['code'] = 2001
            back_dic['msg'] = '请补齐参数!'
            return JsonResponse(back_dic)
        models.Adv.objects.filter(pk=adv_id).update(title=advtitle, content=advcontent, mobile=advphone, img=adv_img,
                                                    is_background_img=int(advlunbo))
        back_dic['code'] = 2000
        back_dic['msg'] = '修改成功!'
        return JsonResponse(back_dic)
    return JsonResponse(back_dic)
```

![image-20240319193813692](https://github.com/ssrheart425/bbs/assets/111131332/68e12a1c-0b16-43c2-bf0a-9d3459eef266)


- html

```html
{% extends 'index.html' %}
{% block guanggao %}
{% load static %}
<div class="layui-carousel" id="ID-carousel-demo-image">
    <div carousel-item>
        {% for data in adv_data %}
        {% if data.is_background_img %}
        <div><img src="/media/{{ data.img }}/" style="height: 360px;width: 720px"></div>
        {% endif %}
        {% endfor %}
    </div>
</div>
<div class="panel panel-primary">
    <div class="panel-heading">
        <h3 class="panel-title text-center">广告中心
        </h3>
    </div>
    <input type="submit" class="btn btn-danger" value="添加广告" id="gg_model" data-toggle="modal"
           data-target="#myModal">
    <!-- Modal -->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                                                                                                      aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title text-center" id="myModalLabel">添加广告信息</h4>
                </div>
                <div class="modal-body">
                    <form action="" id="myform">
                        {% csrf_token %}
                        <div class="text-center">
                            <label for="title">广告标题</label>
                            <p><input type="text" class="form-control text-center" id="title" name="title"></p>
                        </div>
                        <div class="text-center">
                            <label for="content">广告内容</label>
                            <p><input type="text" class="form-control text-center" id="content" name="content"></p>
                        </div>
                        <div class="text-center">
                            <label for="phone">手机号</label>
                            <p><input type="text" class="form-control text-center" id="phone" name="phone"></p>
                        </div>
                        <br>
                        <div class="text-center">
                            <label for="myfile">图片<img src="{% static 'img/kaixin.png' %}" alt="img_check"
                                                       style="height: 80px;width: 80px" id="myimg">
                            </label>
                            <p><input type="file" id="myfile" name="img" style="display: None"></p>
                        </div>
                        <div class="text-center">
                            <label for="lunbo">是否轮播图</label>
                            <input type="radio" name="lunbo" value="1">是
                            <input type="radio" name="lunbo" value="0" checked>否
                        </div>

                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="adv_edit">提交</button>
                </div>

            </div>
        </div>
    </div>
    <div class="panel-body">
        <table class="table">
            <thead>
                <tr>
                    <th>序号</th>
                    <th>标题</th>
                    <th>内容</th>
                    <th>创建时间</th>
                    <th>更新时间</th>
                    <th>手机号</th>
                    <th>广告图片</th>
                    <th>轮播图</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                {% for adv in page_queryset %}
                <tr class="active">
                    <th scope="row">{{ forloop.counter }}</th>
                    <td>{{ adv.title }}</td>
                    <td>{{ adv.content }}</td>
                    <td>{{ adv.create_time }}</td>
                    <td>{{ adv.update_time }}</td>
                    <td>{{ adv.mobile }}</td>
                    <td><img src="/media/{{ adv.img }}/" alt="" style="width: auto; height: 80px"></td>
                    <td>{{ adv.is_background_img }}</td>
                    <td>
                        <input type="hidden" name="adv_id" value="{{ adv.pk }}">
                        <button class="btn btn-xs btn-success" value="author_edit" name="adv_edit1"
                                data-toggle="modal" data-target="#myModal{{ adv.pk }}">编辑
                        </button>
                        <!-- Modal -->
                        <div class="modal fade" id="myModal{{ adv.pk }}" tabindex="-1" role="dialog"
                             aria-labelledby="myModalLabel">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span></button>
                                        <h4 class="modal-title text-center" id="myModalLabel">编辑广告</h4>
                                    </div>
                                    <div class="modal-body">
                                        <form action="" id="edit_form_{{ adv.pk }}">
                                            {% csrf_token %}
                                            <div class="text-center">
                                                <label for="title">广告标题</label>
                                                <p><input type="text" class="form-control text-center" id="advtitle"
                                                          name="advtitle" value="{{ adv.title }}"></p>
                                            </div>
                                            <div class="text-center">
                                                <label for="content">广告内容</label>
                                                <p><input type="text" class="form-control text-center"
                                                          id="advcontent"
                                                          name="advcontent" value="{{ adv.content }}"></p>
                                            </div>
                                            <div class="text-center">
                                                <label for="phone">手机号</label>
                                                <p><input type="text" class="form-control text-center" id="advphone"
                                                          name="advphone" value="{{ adv.mobile }}"></p>
                                            </div>
                                            <br>
                                            <div class="text-center">
                                                <label for="advimg_44">图片<img src="/media/{{ adv.img }}/"
                                                                              style="height: 80px;width: 80px"
                                                                              id="advmyimg" class="img-circle">
                                                </label>
                                                <p><input type="file" id="advimg_44" name="img"
                                                          style="display: None">
                                                </p>
                                            </div>
                                            <div class="text-center">
                                                <label for="advlunbo">是否轮播图</label>
                                                <input type="radio" name="advlunbo" value="1">是
                                                <input type="radio" name="advlunbo" value="0" checked>否
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-default" data-dismiss="modal">
                                                    关闭
                                                </button>
                                                <button type="button" class="btn btn-primary btn_bianjibtn"
                                                        id="bianjibtn" value="{{ adv.pk }}" name="btnpk">确定</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <form action="">
                            {% csrf_token %}
                            <button class="btn btn-xs btn-danger delete44" value="{{ adv.pk }}"
                                    name="delete">删除
                            </button>
                        </form>
                    </td>
                    {#  删除#}
                    <script>
                        $(".delete44").click(function (event) {
                            let id = $(this).val();
                            event.preventDefault();
                            swal({
                                title: "确定要删除吗？",
                                icon: "warning",
                                buttons: ['取消', '确定'],
                                dangerMode: true,
                            })
                                .then((willDelete) => {
                                if (willDelete) {
                                    $.ajax({
                                        url: "",
                                        method: "POST",
                                        data: {
                                            'delete': id,
                                            'action': 'del',
                                            'csrfmiddlewaretoken': '{{ csrf_token }}'
                                        },
                                        success: function (data) {
                                            swal("该条数据已删除!", {
                                                icon: "success",
                                            }).then(() => {
                                                location.reload(); // 删除成功后刷新页面
                                            });
                                        }
                                    });
                                }
                            });
                        })
                    </script>
                    <script>
                        $('#advimg_44').change(function () {
                            let imgdata = new FileReader()
                            let imgobj = $(this)[0].files[0];
                            imgdata.readAsDataURL(imgobj);
                            imgdata.onload = function () {
                                $('#advmyimg').attr('src', imgdata.result)
                            }
                        })
                    </script>
                    <script>
                        $('.btn_bianjibtn').click(function () {
                            let form_id = '#edit_form_' + $(this).attr('value')
                            let editData = new FormData();
                            $.each($(form_id).serializeArray(), function (index, obj) {
                                editData.append(obj.name, obj.value);
                            })
                            editData.append('advedit_img', $('#advimg_44')[0].files[0]);
                            editData.append('adv_id', $(this).attr('value'));
                            $.ajax({
                                url: '{% url 'edit_adv' %}',
                                type: 'post',
                                data: editData,
                                processData: false,
                                contentType: false,
                                success: function (args) {
                                if (args.code === 2000) {
                                    swal({
                                        title: args.msg,
                                        icon: "success",
                                        button: true,
                                    }).then(() => {
                                        window.location.reload();
                                    });
                                } else {
                                    swal({
                                        title: args.msg,
                                        icon: "error",
                                        button: true,
                                    }).then(() => {
                                        window.location.reload();
                                    });
                                }
                            }
                        })
                        })
                    </script>
                </tr>
                {% endfor %}
            </tbody>
        </table>
        <div class="text-center">
            {{ page_obj.page_html|safe }}
        </div>
    </div>
</div>



<script>
    $('#myfile').change(function () {
        // 文件阅读器对象
        // 1 先生成一个文件阅读器对象
        let myFileReader = new FileReader();
        // 2 获取用户上传的头像文件
        let fileobj = $(this)[0].files[0];
        // 3 将文件对象交给阅读器读取
        myFileReader.readAsDataURL(fileobj); // 异步操作 IO操作
        // 4 当文件阅读器读取完毕后，将读取到的文件内容赋值给img标签
        myFileReader.onload = function () {
            $('#myimg').attr('src', myFileReader.result);
        }
    })
</script>
<script>
    $('#adv_edit').click(function () {
        let formData = new FormData();
        $.each($('#myform').serializeArray(), function (index, obj) {
            formData.append(obj.name, obj.value);
        })
        formData.append('adv_img', $('#myfile')[0].files[0]);
        $.ajax({
            url: '',
            type: 'post',
            data: formData,
            processData: false,
            contentType: false,
            success: function (args) {
                if (args.code === 2000) {
                    swal({
                        title: args.msg,
                        icon: "success",
                        button: true,
                    }).then(() => {
                        window.location.href = args.url;
                    });
                } else {
                    swal({
                        title: args.msg,
                        icon: "error",
                        button: true,
                    }).then(() => {
                        window.location.reload();
                    });
                }
            }
        })
    })
</script>
{% endblock %}
```

![image-20240319193752814](https://github.com/ssrheart425/bbs/assets/111131332/9fc37b35-8f8d-47dd-9de7-a656ccb76c7f)


## 轮播图

```html
<script src="//unpkg.com/layui@2.9.7/dist/layui.js"></script>
<script>
    layui.use(function () {
        var carousel = layui.carousel;
        carousel.render({
            elem: '#ID-carousel-demo-image',
            width: '720px',
            height: '360px',
            interval: 3000
        });
    });
</script>
```

# article 个人站点

## 路由配置

```
from django.urls import path, re_path
from article import views

urlpatterns = [
    path('up_down/', views.up_down, name='up_down'),
    path('comment/', views.comment, name='comment'),
]
```

## 首页搭建

- py

```python
def site(request, username, **kwargs):
    article_obj = Article.objects.filter(blog__userinfo__username=username)
    blog_data = Blog.objects.get(userinfo__username=username)
    current_page = request.GET.get("page", 1)
    all_count = article_obj.count()
    page_obj = Pagination(current_page=current_page, all_count=all_count, per_page_num=5)
    page_queryset = article_obj[page_obj.start:page_obj.end]
    category_data = Category.objects.filter(blog__userinfo__username=username).annotate(
        article_num=Count('article__pk')
    ).values('id', 'name', 'article_num')
    condition = kwargs.get('condition')
    param = kwargs.get('param')
    if condition and param:
        if condition == 'category':
            page_queryset = Article.objects.filter(category__pk=int(param))
        elif condition == 'tag':
            page_queryset = Article.objects.filter(tags__pk=int(param))
        elif condition == 'archive':
            year, month = param.split('-')
            page_queryset = Article.objects.filter(create_time__year=year, create_time__month=month)
        else:
            return redirect('site')

    Tag_data = Tag.objects.filter(blog__userinfo__username=username).annotate(
        tag_num=Count('article__pk')
    ).values('id', 'name', 'tag_num')

    time_data = Article.objects.filter(blog__userinfo__username=username).annotate(
        create_num=TruncMonth('create_time')).values('create_num').annotate(
        article_num=Count('pk')
    ).values('create_num', 'article_num')

    dianzan_data = Article.objects.filter(blog__userinfo__username=username).order_by(
        '-up_num').values('title', 'up_num')

    return render(request, 'site.html', locals())
```

- html

```html
{% extends 'index.html' %}

{% block fluid %}
    {% load static %}
    <link rel="stylesheet" href="/static/css/{{ blog_data.site_theme }}">
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-2">
                <div class="bs-example" data-example-id="contextual-panels">
                    <div class="panel panel-primary">
                        <div class="panel-heading">
                            <h3 class="panel-title">我的分类</h3>
                        </div>
                        {% for cat_obj in category_data %}
                            <div class="panel-body">
                                <a href="{% url 'article_left' username 'category' cat_obj.id %}">{{ cat_obj.name }}({{ cat_obj.article_num }})</a>
                                <hr>
                            </div>
                        {% endfor %}
                    </div>

                    <div class="panel panel-success">
                        <div class="panel-heading">
                            <h3 class="panel-title">随笔标签</h3>
                        </div>
                        {% for tag_obj in Tag_data %}
                            <div class="panel-body">
                                <a href="{% url 'article_left' username 'tag' tag_obj.id %}">{{ tag_obj.name }}({{ tag_obj.tag_num }})</a>
                                <hr>
                            </div>
                        {% endfor %}
                    </div>
                    <div class="panel panel-info">
                        <div class="panel-heading">
                            <h3 class="panel-title">随笔档案</h3>
                        </div>
                        {% for time_obj in time_data %}
                            <div class="panel-body">
                                <a href="{% url 'article_left' username 'archive' time_obj.create_num|date:'Y-m' %}">{{ time_obj.create_num|date:'Y-m' }}({{ time_obj.article_num }})</a>
                            </div>
                        {% endfor %}
                    </div>
                    <div class="panel panel-warning">
                        <div class="panel-heading">
                            <h3 class="panel-title">点赞排行</h3>
                        </div>
                        {% for dianzan_obj in dianzan_data %}
                            <div class="panel-body">
                                <a href="">{{ dianzan_obj.title }}({{ dianzan_obj.up_num }})</a>
                            </div>
                        {% endfor %}


                    </div>
                </div>
            </div>
            {% block detail %}
                <div class="col-md-10">
                    {% for atc_data in page_queryset %}
                        <div class="media">
                            <h4 class="media-heading"><a
                                    href="{% url 'article_detail' username atc_data.pk %}">{{ atc_data.title }}</a></h4>
                            <div class="media-left">
                                <a href="#">
                                    <img class="media-object" data-src="holder.js/64x64" alt="64x64"
                                         src="/media/{{ atc_data.blog.userinfo.avatar }}/"
                                         data-holder-rendered="true" style="width: 64px; height: 64px;">
                                </a>
                            </div>
                            <div class="media-body">
                                摘要: &nbsp {{ atc_data.desc }}
                            </div>

                        </div>
                        <div class="media-bottom pull-right">
                            <br>
                            <style>
                                span {
                                    color: grey
                                }
                            </style>
                            <span style="margin-left: 10px">posted @ {{ atc_data.create_time }}</span>
                            <span style="margin-left: 10px">{{ atc_data.blog.userinfo.username }}</span>
                            <span class="glyphicon glyphicon-thumbs-up"
                                  style="margin-left: 10px">{{ atc_data.up_num }}</span>
                            <span class="glyphicon glyphicon-thumbs-down"
                                  style="margin-left: 10px">{{ atc_data.up_down }}</span>
                            <span class="glyphicon glyphicon-comment"
                                  style="margin-left: 10px">{{ atc_data.comment_num }}</span>
                        </div>
                        <br>
                        <hr>
                    {% endfor %}
                </div>
            {% endblock %}
            <div class="text-center">
                {{ page_obj.page_html|safe }}
            </div>
        </div>
    </div>
{% endblock %}
```

![image-20240329093949428](https://github.com/ssrheart425/bbs/assets/111131332/38180e6a-35bb-410c-97ea-20b65cab56f9)


## 详情页搭建

- py

```python
def article_detail(request, username, pk, **kwargs):
    detail_art = Article.objects.get(pk=pk)
    article_obj = Article.objects.filter(blog__userinfo__username=username)
    article_obj1 = Article.objects.filter(blog__userinfo__username=username).first()
    blog_data = Blog.objects.get(userinfo__username=username)
    current_page = request.GET.get("page", 1)
    all_count = article_obj.count()
    page_obj = Pagination(current_page=current_page, all_count=all_count, per_page_num=5)
    page_queryset = article_obj[page_obj.start:page_obj.end]
    category_data = Category.objects.filter(blog__userinfo__username=username).annotate(
        article_num=Count('article__pk')
    ).values('id', 'name', 'article_num')
    condition = kwargs.get('condition')
    param = kwargs.get('param')

    comment_obj = Comment.objects.filter(article_id=pk)

    if condition and param:
        if condition == 'category':
            page_queryset = Article.objects.filter(category__pk=int(param))
        elif condition == 'tag':
            page_queryset = Article.objects.filter(tags__pk=int(param))
        elif condition == 'archive':
            year, month = param.split('-')
            page_queryset = Article.objects.filter(create_time__year=year, create_time__month=month)
        else:
            return redirect('site')

    Tag_data = Tag.objects.filter(blog__userinfo__username=username).annotate(
        tag_num=Count('article__pk')
    ).values('id', 'name', 'tag_num')

    time_data = Article.objects.filter(blog__userinfo__username=username).annotate(
        create_num=TruncMonth('create_time')).values('create_num').annotate(
        article_num=Count('pk')
    ).values('create_num', 'article_num')

    dianzan_data = Article.objects.filter(blog__userinfo__username=username).order_by(
        '-up_num').values('title', 'up_num')

    return render(request, 'article_detail.html', locals())
```

- html

```html
{% extends 'site.html' %}
{% load static %}
{% block detail %}
    <style>
        #div_digg {
            float: right;
            margin-bottom: 10px;
            margin-right: 30px;
            font-size: 12px;
            width: 128px;
            text-align: center;
            margin-top: 10px;
        }

        .diggit {
            float: left;
            width: 46px;
            height: 52px;
            background: url({% static 'img/upup.gif' %}) no-repeat;
            text-align: center;
            cursor: pointer;
            margin-top: 2px;
            padding-top: 5px;
        }

        .buryit {
            float: right;
            margin-left: 20px;
            width: 46px;
            height: 52px;
            background: url({% static 'img/downdown.gif' %}) no-repeat;
            text-align: center;
            cursor: pointer;
            margin-top: 2px;
            padding-top: 5px;
        }

        .clear {
            clear: both;
        }


        .diggword {
            margin-top: 5px;
            margin-left: 0;
            font-size: 12px;
            color: #808080;
        }
    </style>
    <div class="media">
        {% csrf_token %}
        <div class="pull-right">
            <span>随笔 - {{ all_count }} 点赞数 - {{ detail_art.up_num }} 点踩数 - {{ detail_art.up_down }} 评论数 - {{ detail_art.comment_num }}</span>
        </div>
        <br>
        <div class="media-heading">
            <a href=""><h2>{{ detail_art }}</h2></a>
            <hr>
        </div>
        <div class="media-body">
            <p>{{ detail_art.content|safe }}</p>
        </div>
        {#点赞#}
        <div class="clearfix">
            <div class="pull-right">
                <div class="media-bottom">
                    <div id="div_digg">
                        <div class="diggit" onclick="votePost({{ detail_art.pk }},'Digg')">
                            <span class="diggnum" id="digg_count">{{ detail_art.up_num }}</span>
                        </div>
                        <div class="buryit" onclick="votePost({{ detail_art.pk }},'Bury')">
                            <span class="burynum" id="bury_count">{{ detail_art.up_down }}</span>
                        </div>
                        <div class="clear"></div>
                        <div class="diggword" id="digg_tips">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        posted @ {{ detail_art.create_time|date:'Y-m-d' }}
        <a href="{% url 'site' article_obj1.blog.site_name %}">{{ article_obj1.blog.site_name }}</a>
        评论({{ detail_art.comment_num }})
        <br>
        <hr>
        {% if request.user.is_authenticated %}
            <h3>评论列表</h3>
            <hr>
            {% for comment in comment_obj %}
                {% if not comment.parent %}
                    <div>
                        <p>#{{ forloop.counter }}楼 {{ comment.comment_time|date:'Y-m-d H:i:s' }} @<a
                                href="{% url 'site' comment.user.username %}">{{ comment.user.username }}</a>
                            <a href="#comment_area" style="color: red" class="pull-right comment_replay"
                               replay_username='{{ comment.user.username }}' parent_id= {{ comment.pk }}>回复</a>&nbsp;&nbsp;&nbsp;
                        </p>
                        <p>{{ comment.content }}</p>
                        {% for comment1 in comment_obj %}
                            {% if comment1.parent.pk  == comment.pk %}
                                @  <a href="{% url 'site' comment.user.username %}">{{ comment1.parent.user.username }} </a><p>{{ comment1.content }}</p>
                            {% endif %}

                        {% endfor %}
                        <hr>
                        <br>
                    </div>
                {% endif %}

            {% endfor %}
            <h3>发表评论</h3>
            <textarea name="" id="comment_area" cols="30" rows="10" class="form-control"></textarea>
            <br>
            <button class="btn btn-primary" id="submit_comment">提交评论</button>
        {% else %}
            <p>登录后才能查看或发表评论，立即<a href="{% url 'login' %}" style="color: red">登录</a></p>
        {% endif %}
    </div>



    <script>
        function votePost(id, tag) {
            let tipes = $('#digg_tips');
            let data = {
                'id': id,
                // 三元表达式
                'up_down': 1 ? tag === 'Digg' : 0,
                'csrfmiddlewaretoken': "{{ csrf_token }}",
            }
            $.ajax({
                url: '{% url 'up_down' %}',
                type: 'post',
                data: data,
                success: function (args) {
                    if (args.code === 1000) {
                        tipes.text(args.msg)
                        if (args.msg === '点赞成功!') {
                            $('#digg_count').text(parseInt($('#digg_count').text()) + 1)
                        } else {
                            $('#bury_count').text(parseInt($('#bury_count').text()) + 1)
                        }
                    } else {
                        tipes.text(args.msg)
                    }
                }
            })
        }
    </script>
    <script>
        let parentID = null;
        $('#submit_comment').click(function () {
            let content = $('#comment_area').val()
            if (parentID) {
                let clearNum = content.indexOf("\n") + 1
                content = content.slice(clearNum)
            }
            $.ajax({
                url: '{% url 'comment' %}',
                type: 'post',
                data: {
                    'content': content,
                    'csrfmiddlewaretoken': "{{ csrf_token }}",
                    'parentID': parentID,
                    'article_id': '{{ detail_art.pk }}'
                },
                success: function (args) {
                    if (args.code === 1000) {
                        swal({
                            title: args.msg,
                            icon: "success",
                            button: true,
                        }).then(() => {
                            window.location.reload()
                        });
                    } else {
                        swal({
                            title: args.msg,
                            icon: "error",
                            button: true,
                        }).then(() => {
                            window.location.reload();
                        });
                    }
                }
            })
        })
        $('.comment_replay').click(function () {
            let username = $(this).attr('replay_username')
            $('#comment_area').text('@' + username + '\n')
            parentID = $(this).attr('parent_id')
        })
    </script>
{% endblock %}
```

## 点赞、评论功能

- py

```python
def up_down(request):
    if request.method == 'POST' and request.is_ajax():
        back_dict = {'code': 1000, 'msg': '点赞成功!'}
        if not request.user.is_authenticated:
            back_dict['code'] = 1001
            back_dict['msg'] = '请先登录!'
            return JsonResponse(back_dict)
        data = request.POST
        article_id = data.get('id')
        up_down = json.loads(data.get('up_down'))  # True False
        user_obj = request.user
        article_obj = Article.objects.filter(pk=int(article_id)).first()
        up_down_obj = UpAndDown.objects.filter(user=user_obj, article=article_obj)
        if up_down_obj:
            back_dict['code'] = 1002
            back_dict['msg'] = '当前用户已经点赞或点踩过了!'
            return JsonResponse(back_dict)
        UpAndDown.objects.create(user=user_obj, article=article_obj, is_up=up_down)
        updown_obj = Article.objects.filter(pk=int(article_id)).first()
        if up_down:
            updown_obj.up_num += 1
            updown_obj.save()
            back_dict['code'] = 1000
            back_dict['msg'] = '点赞成功!'
            return JsonResponse(back_dict)
        else:
            updown_obj.up_down += 1
            updown_obj.save()
            back_dict['code'] = 1000
            back_dict['msg'] = '点踩成功!'
            return JsonResponse(back_dict)
        return JsonResponse(back_dict)
    return HttpResponse('ok')


def comment(request):
    back_dict = {'code': 1000, 'msg': '评论成功!'}
    if request.method == 'POST' and request.is_ajax():
        # 评论
        data = request.POST
        content = data.get('content')
        article_id = data.get('article_id')
        parent_id = data.get('parentID')
        if not content:
            back_dict['code'] = 1001
            back_dict['msg'] = '评论内容不能为空!'
            return JsonResponse(back_dict)
        Comment.objects.create(user=request.user, article_id=int(article_id), content=content, parent_id=parent_id)
        res = Comment.objects.filter(article_id=article_id).first()
        res.article.comment_num += 1
        res.article.save()
        return JsonResponse(back_dict)
```









# admin 管理

## user/admin

- 显示头像

```python
from django.utils.html import format_html
class ...
    def display_avatar(self, obj):
        # 获取默认的avatar路径
        avatar_path = obj.avatar if obj.avatar else 'static/avatar/default.png'
        # 拼接完整的URL
        avatar_url = f'http://127.0.0.1:8000/media/{avatar_path}'

        return format_html(
            f'<a href="{avatar_url}" target="_blank">'
            f'<img src="{avatar_url}"  alt="请稍后再试哦" style="width: 50px;height: auto">'
            f'</a>')

    display_avatar.short_description = "用户头像"
```

- 完整配置

```python
from django.contrib import admin

# Register your models here.
from user.models import UserInfo
from django.utils.html import format_html
@admin.register(UserInfo)
class UserInfoAdmin(admin.ModelAdmin):
    ordering = ['id']

    # 想要对某个字段进行额外的处理渲染指定的样式 需要重写一个函数
    def display_avatar(self, obj):
        # 获取默认的avatar路径
        avatar_path = obj.avatar if obj.avatar else 'static/avatar/default.png'
        # 拼接完整的URL
        avatar_url = f'http://127.0.0.1:8000/media/{avatar_path}'

        return format_html(
            f'<a href="{avatar_url}" target="_blank">'
            f'<img src="{avatar_url}"  alt="请稍后再试哦" style="width: 50px;height: auto">'
            f'</a>')

    display_avatar.short_description = "用户头像"
    list_display = ['id', 'username', 'is_superuser', 'email', 'phone', 'display_avatar', 'create_time', 'is_deleted','blog']
```

# backend 后台管理

## 路由配置

```python
# -*- coding: utf-8 -*-
# author : heart
# blog_url : https://www.cnblogs.com/ssrheart/
# time : 2024/3/27

from django.urls import path, re_path
from backend import views

urlpatterns = [
    path('', views.backend, name='backend'),
    path('backendlogout/', views.backendlogout, name='backendlogout'),
    path('backend_category/', views.backend_category, name='backend_category'),
    path('backend_tag/', views.backend_tag, name='backend_tag'),
    path('backend_comment/', views.backend_comment, name='backend_comment'),
    path('backend_add_article/', views.backend_add_article, name='backend_add_article'),
]
```

```python
from django.shortcuts import render
from django.db.models import Count
from django.db.models.functions import TruncMonth
from django.http import JsonResponse
from django.shortcuts import render, redirect, HttpResponse

from article.models import Article, Category, Tag, UpAndDown, Comment
from blog.fenyeqi import Pagination
from blog.models import Blog


def backend(request):
    user = request.user
    category_data = Category.objects.filter(blog__userinfo__username=user).annotate(
        article_num=Count('article__pk')
    ).values('id', 'name', 'article_num')

    tag_data = Tag.objects.filter(blog__userinfo__username=user).annotate(
        tag_num=Count('article__pk')
    ).values('id', 'name', 'tag_num')

    article_data = Article.objects.filter(blog__userinfo__username=user)
    current_page = request.GET.get("page", 1)
    all_count = article_data.count()
    page_obj = Pagination(current_page=current_page, all_count=all_count, per_page_num=5)
    page_queryset = article_data[page_obj.start:page_obj.end]

    article_category = Category.objects.filter(blog__userinfo__username=user)
    article_tag = Tag.objects.filter(blog__userinfo__username=user)
    if request.method == 'POST' and request.is_ajax():
        data = request.POST
        pk = data.get('pk')
        tag = data.get('tag')
        art_pk = data.get('art_pk')
        title = data.get('art_title')
        art_content = data.get('art_content')
        art_desc = data.get('art_desc')
        art_tag = data.get('art_tag')

        cate_a = data.get('cate_a')
        tag_a = data.getlist('tag_a[]')
        if tag == 'delete':
            Article.objects.filter(pk=pk).delete()
            return JsonResponse({'code': 404, 'msg': '删除成功!'})
        if art_tag == 'edit':
            if not all([title, art_content, art_desc, cate_a, tag_a]):
                return JsonResponse({'code': 404, 'msg': '请填写完整!'})
            cate_obj = Category.objects.filter(pk=cate_a).first()
            res = Article.objects.filter(pk=art_pk).first()
            res.title = title
            res.content = art_content
            res.desc = art_desc
            res.category = cate_obj
            res.tags.set([i for i in tag_a])
            res.save()
            return JsonResponse({'code': 2000, 'msg': '修改成功!'})
    return render(request, 'backend.html', locals())


def backend_category(request):
    user = request.user
    category_data = Category.objects.filter(blog__userinfo__username=user).annotate(
        article_num=Count('article__pk')
    ).values('id', 'name', 'article_num')

    tag_data = Tag.objects.filter(blog__userinfo__username=user).annotate(
        tag_num=Count('article__pk')
    ).values('id', 'name', 'tag_num')

    category_obj = Category.objects.filter(blog__userinfo__username=user).values(
        'article__title', 'name'
    )
    current_page = request.GET.get("page", 1)
    all_count = category_obj.count()
    page_obj = Pagination(current_page=current_page, all_count=all_count, per_page_num=5)
    page_queryset = category_obj[page_obj.start:page_obj.end]

    return render(request, 'backend_category.html', locals())


def backend_tag(request):
    user = request.user
    category_data = Category.objects.filter(blog__userinfo__username=user).annotate(
        article_num=Count('article__pk')
    ).values('id', 'name', 'article_num')

    tag_data = Tag.objects.filter(blog__userinfo__username=user).annotate(
        tag_num=Count('article__pk')
    ).values('id', 'name', 'tag_num')

    tag_obj = Tag.objects.filter(blog__userinfo__username=user).values(
        'article__title', 'name'
    )
    current_page = request.GET.get("page", 1)
    all_count = tag_obj.count()
    page_obj = Pagination(current_page=current_page, all_count=all_count, per_page_num=5)
    page_queryset = tag_obj[page_obj.start:page_obj.end]

    return render(request, 'backend_tag.html', locals())


def backend_comment(request):
    user = request.user
    category_data = Category.objects.filter(blog__userinfo__username=user).annotate(
        article_num=Count('article__pk')
    ).values('id', 'name', 'article_num')

    tag_data = Tag.objects.filter(blog__userinfo__username=user).annotate(
        tag_num=Count('article__pk')
    ).values('id', 'name', 'tag_num')

    comment_obj = Comment.objects.filter(user=user).values(
        'article__title', 'content', 'comment_time'
    )
    current_page = request.GET.get("page", 1)
    all_count = comment_obj.count()
    page_obj = Pagination(current_page=current_page, all_count=all_count, per_page_num=5)
    page_queryset = comment_obj[page_obj.start:page_obj.end]

    return render(request, 'backend_comment.html', locals())


def backend_add_article(request):
    user = request.user
    category_data = Category.objects.filter(blog__userinfo__username=user).annotate(
        article_num=Count('article__pk')
    ).values('id', 'name', 'article_num')

    tag_data = Tag.objects.filter(blog__userinfo__username=user).annotate(
        tag_num=Count('article__pk')
    ).values('id', 'name', 'tag_num')
    article_category = Category.objects.filter(blog__userinfo__username=user)
    article_tag = Tag.objects.filter(blog__userinfo__username=user)
    back_dict = {'code': 2000, 'msg': '添加成功!'}
    if request.method == 'POST' and request.is_ajax():
        data = request.POST
        biaoti = data.get('biaoti')
        neirong = data.get('neirong')
        fenlei = data.get('fenlei')
        tag = data.getlist('tag[]')
        desc = data.get('desc')
        if not all([biaoti, neirong, fenlei, tag]):
            back_dict['code'] = 2001
            back_dict['msg'] = '请填写完整!'
            return JsonResponse(back_dict)
        category_obj = Category.objects.filter(name=fenlei).first()
        blog_obj = Blog.objects.filter(userinfo__username=user).first()
        Article.objects.create(title=biaoti, content=neirong, desc=desc, blog=blog_obj, category=category_obj)
        article = Article.objects.filter(title=biaoti).first()
        for i in tag:
            article.tags.add(i)
            article.save()
        return JsonResponse(back_dict)
    return render(request, 'backend_add_article.html', locals())


def backendlogout(request):
    request.session.flush()
    return redirect('index')
```

- backend.html

```html
<!-- -*- coding: utf-8 -*- -->
<!-- author : heart -->
<!-- blog_url : https://www.cnblogs.com/ssrheart/ -->
<!-- time : 2024/3/27 -->
{% load static %}
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/3.4.1/js/bootstrap.min.js"></script>
    <script src="{% static 'js/sweetalert.min.js' %}"></script>
    <link href="//unpkg.com/layui@2.9.7/dist/css/layui.css" rel="stylesheet">
    <script src="//unpkg.com/layui@2.9.7/dist/layui.js"></script>
</head>
<body>
{#导航栏#}
<nav class="navbar navbar-default">
    <div class="container-fluid">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                    data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="{% url 'index' %}">首页</a>
        </div>

        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li class="active"><a href="#">新闻 <span class="sr-only">(current)</span></a></li>
                <li><a href="#">动态</a></li>
                <li><a href="#">博问</a></li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                {% if request.user.is_authenticated %}
                    <li><a href="#">{{ request.user }}</a></li>
                    <li><a href="{% url 'backendlogout' %}">退出登录</a></li>
                {% else %}
                    <li><a href="{% url 'login' %}">登录</a></li>
                {% endif %}


            </ul>
        </div><!-- /.navbar-collapse -->
    </div><!-- /.container-fluid -->
</nav>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-offset-1">
            <div class="col-md-8">
                <a href="{% url 'index' %}"><img src="media/advImg/logo.png" alt=""
                                                 style="width: auto;height: 50px"></a>
            </div>
        </div>
        <div class="col-md-1 pull-right">
            <h2><a href="{% url 'site' request.user %}" style="color: blue">{{ request.user }}</a></h2>
        </div>
    </div>
    <br><br><br><br>
    <div class="row">
        <div class="col-md-2">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title text-center">随笔管理</h3>
                </div>
                <div class="panel-body">
                    <p><a href="{% url 'backend_add_article' %}" class="glyphicon glyphicon-plus-sign">新建随笔</a></p>
                    <p><a href="" class="glyphicon glyphicon-folder-open">随笔模版</a></p>
                    <p><a href="">草稿箱</a></p>
                </div>
            </div>
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title text-center">分类管理</h3>
                </div>
                <div class="panel-body">
                    <p><a href="" class="glyphicon glyphicon-plus-sign">新建分类</a></p>
                    <p><a href="" class="glyphicon glyphicon-folder-open">分类模版</a></p>
                    <hr>
                    <h4 class="text-center" style="color: red">分类展示</h4>
                    <br>
                    {% for fenlei_obj in category_data %}
                        <div>
                            <p><a href="">{{ fenlei_obj.name }}({{ fenlei_obj.article_num }})</a></p>
                            <br>
                        </div>
                    {% endfor %}
                    <hr>
                </div>
            </div>
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title text-center">标签管理</h3>
                </div>
                <div class="panel-body">
                    <p><a href="" class="glyphicon glyphicon-plus-sign">新建标签</a></p>
                    <p><a href="" class="glyphicon glyphicon-folder-open">标签模版</a></p>
                    <hr>
                    <h4 class="text-center" style="color: red">标签展示</h4>
                    <br>
                    {% for tag_obj in tag_data %}
                        <div>
                            {{ tag_obj.name }}({{ tag_obj.tag_num }})
                        </div>
                        <br>
                    {% endfor %}
                    <hr>
                </div>
            </div>
        </div>
        {% block backend_right %}
            <div class="col-md-10">
                <ul id="myTabs" class="nav nav-tabs" role="tablist">
                    <li role="presentation" class=""><a href="{% url 'backend_add_article' %}" id="add_article"
                                                        role="tab"
                                                        data-toggle="tab"
                                                        aria-controls="profile" aria-expanded="false">添加文章</a>
                    </li>
                    <li role="presentation" class="active"><a href="{% url 'backend' %}" id="home-tab" role="tab"
                                                              data-toggle="tab"
                                                              aria-controls="home" aria-expanded="true">随笔</a></li>
                    <li role="presentation" class=""><a href="{% url 'backend_category' %}" role="tab" id="profile-tab"
                                                        data-toggle="tab"
                                                        aria-controls="profile" aria-expanded="false">分类</a></li>
                    <li role="presentation" class=""><a href="{% url 'backend_tag' %}" role="tab" id="profile-tab"
                                                        data-toggle="tab"
                                                        aria-controls="profile" aria-expanded="false">标签</a></li>
                    <li role="presentation" class=""><a href="{% url 'backend_comment' %}" role="tab" id="profile-tab"
                                                        data-toggle="tab"
                                                        aria-controls="profile" aria-expanded="false">评论</a></li>
                </ul>
                <br>
                <table class="table table-striped">
                    {% csrf_token %}
                    <thead>
                    <tr>
                        <th>标题</th>
                        <th>发布时间</th>
                        <th>点赞数</th>
                        <th>点踩数</th>
                        <th>评论数</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        {% for article_obj in page_queryset %}
                            <td>
                                <a href="{% url 'article_detail'  request.user article_obj.pk %}">{{ article_obj.title }}</a>
                            </td>
                            <td>{{ article_obj.create_time|date:'Y-m-d' }}</td>
                            <td>{{ article_obj.up_num }}</td>
                            <td>{{ article_obj.up_down }}</td>
                            <td>{{ article_obj.comment_num }}</td>
                            <td>
                                <button class="btn btn-primary btn-xs edit" data-toggle="modal"
                                        data-target="#myModal{{ article_obj.pk }}" value="{{ article_obj.pk }}"
                                        id="edit_btn">编辑
                                </button>
                                <div class="modal fade myModal" tabindex="-1" role="dialog"
                                     id="myModal{{ article_obj.pk }}">
                                    <div class="modal-dialog" role="document">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <button type="button" class="close" data-dismiss="modal"
                                                        aria-label="Close"><span aria-hidden="true">&times;</span>
                                                </button>
                                                <h4 class="modal-title text-center">修改随笔信息</h4>
                                            </div>
                                            <div class="modal-body">
                                                <div class="form-group">
                                                    <p class="text-center"><label for="art_title">标题</label></p>
                                                    <input type="text" value="{{ article_obj.title }}"
                                                           class="form-control text-center" name="art_title"
                                                           id="art_title">
                                                </div>
                                                <div class="form-group">
                                                    <p class="text-center"><label>内容</label></p>
                                                    <textarea class="form-control text-center" id="art_content"
                                                              cols="30"
                                                              rows="10"
                                                              name="art_content">{{ article_obj.content }}</textarea>
                                                </div>
                                                <div class="form-group">
                                                    <p class="text-center"><label for="art_desc">简介</label></p>
                                                    <input type="text" value="{{ article_obj.desc }}"
                                                           class="form-control text-center" name="art_desc"
                                                           id="art_desc">
                                                </div>

                                                <div class="form-group">
                                                    <p class="text-center"><label for="cate_a">选择分类</label></p>
                                                    <select name="cate_a" id="cate_a" class="form-control">
                                                        <option value="" disabled="" selected="">选择分类</option>
                                                        {% for cate_a in article_category %}
                                                            <option value="{{ cate_a.pk }}">{{ cate_a.name }}</option>
                                                        {% endfor %}
                                                    </select>
                                                </div>

                                                <div class="form-group">
                                                    <p class="text-center"><label for="tag_a">选择标签</label></p>
                                                    <select name="tag_a" id="tag_a" class="form-control"
                                                            multiple>
                                                        <option value="" disabled="" selected="">选择标签</option>
                                                        {% for tag_a in article_tag %}
                                                            <option value="{{ tag_a.pk }}">{{ tag_a.name }}</option>
                                                        {% endfor %}
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-default" data-dismiss="modal">
                                                    关闭
                                                </button>
                                                <button type="button" class="btn btn-primary art_edit">提交
                                                </button>
                                            </div>
                                        </div><!-- /.modal-content -->
                                    </div><!-- /.modal-dialog -->
                                </div><!-- /.modal -->
                                <button class="btn btn-danger btn-xs delete" value="{{ article_obj.pk }}">删除</button>
                            </td>
                            </tr>
                        {% endfor %}
                    </tbody>
                </table>
            </div>
            <div class="text-center">{{ page_obj.page_html|safe }}</div>
        {% endblock %}
    </div>
    <script>
        // 使用jQuery捕获点击事件并执行页面重定向
        $(document).ready(function () {
            $('ul.nav-tabs a').click(function (e) {
                e.preventDefault(); // 阻止默认的链接跳转行为
                var url = $(this).attr('href'); // 获取被点击链接的URL
                window.location.href = url; // 执行页面跳转
            });
        });
    </script>
    <script>
        $('.delete').click(function () {
            let pk = $(this).attr('value');
            swal({
                title: "确定要删除吗？",
                icon: "warning",
                buttons: ['取消', '确定'],
                dangerMode: true,
            }).then((willDelete) => {
                if (willDelete) {
                    $.ajax({
                        url: '{% url 'backend' %}',
                        type: 'post',
                        data: {
                            'pk': pk,
                            'csrfmiddlewaretoken': '{{ csrf_token }}',
                            'tag': 'delete'
                        },
                        success: function (data) {
                            swal(data.msg, {
                                icon: "success",
                            }).then(() => {
                                location.reload(); // 删除成功后刷新页面
                            });
                        }
                    });
                }
            });
        });
    </script>
    <script>
        $('.art_edit').click(function () {
            let data = {}
            data['art_pk'] = $('#edit_btn').val();
            data['art_title'] = $('#art_title').val();
            data['art_content'] = $('#art_content').val();
            data['art_desc'] = $('#art_desc').val();
            data['art_tag'] = 'edit';
            data['cate_a'] = $('#cate_a').val();
            data['tag_a'] = $('#tag_a').val();
            data['csrfmiddlewaretoken'] = '{{ csrf_token }}';
            $.ajax({
                url: '{% url 'backend' %}',
                type: 'post',
                data: data,
                success: function (args) {
                    if (args.code === 2000) {
                        swal({
                            title: args.msg,
                            icon: "success",
                            button: true,
                        }).then(() => {
                            window.location.reload();
                        });
                    }
                }
            })
        });
    </script>
</div>
</body>
</html>
```

- backend_add_article.html

```html
{% extends 'backend.html' %}
{% block backend_right %}
    {% load static %}
    <script charset="utf-8" src="{% static 'Editor/kindeditor/kindeditor-all-min.js' %}"></script>
    <script charset="utf-8" src="{% static 'Editor/kindeditor/lang/zh-CN.js' %}"></script>
    <div class="col-md-10">
        <ul id="myTabs" class="nav nav-tabs" role="tablist">
            <li role="presentation" class="active"><a href="{% url 'backend_add_article' %}" id="add_article" role="tab"
                                                      data-toggle="tab"
                                                      aria-controls="profile" aria-expanded="true">添加文章</a></li>
            <li role="presentation" class=""><a href="{% url 'backend' %}" id="home-tab" role="tab"
                                                data-toggle="tab"
                                                aria-controls="profile" aria-expanded="false">随笔</a></li>
            <li role="presentation" class=""><a href="{% url 'backend_category' %}" role="tab" id="profile-tab"
                                                data-toggle="tab"
                                                aria-controls="categories" aria-expanded="false">分类</a></li>
            <li role="presentation" class=""><a href="{% url 'backend_tag' %}" role="tab" id="profile-tab"
                                                data-toggle="tab"
                                                aria-controls="tags" aria-expanded="false">标签</a></li>
            <li role="presentation" class=""><a href="{% url 'backend_comment' %}" role="tab" id="profile-tab"
                                                data-toggle="tab"
                                                aria-controls="comments" aria-expanded="false">评论</a></li>
        </ul>
        <br>
        <form id="form_tijiao">
            {% csrf_token %}
            <div class="alert alert-info" role="alert">添加文章</div>
            <div class="form-group">
                <label for="biaoti">标题</label>
                <input type="text" class="form-control" id="biaoti" name="biaoti">
            </div>
            <br>
            <div class="form-group">
                <label for="article_content">文章内容</label>
                <textarea name="neirong" id="article_content" cols="30" rows="10" class="form-control"
                          required></textarea>
            </div>
            <div class="form-group">
                <label for="desc">文章简介</label>
                <input type="text" class="form-control" id="desc" name="desc">
            </div>
            <div class="form-group">
                <label for="fenlei">文章分类</label>
                <select name="fenlei" id="fenlei" class="form-control">
                    <option value="" disabled selected>选择分类</option>
                    {% for article_obj in article_category %}
                        <option value="{{ article_obj.name }}">{{ article_obj.name }}</option>
                    {% endfor %}
                </select>
            </div>

            <div class="form-group">
                <label>文章标签</label><br>
                {% for tag_obj in article_tag %}
                    <input type="checkbox" value="{{ tag_obj.pk }}" name="tag" id="tag">{{ tag_obj.name }}
                {% endfor %}
            </div>
            <button class="btn btn-primary form-control" id="tijiao">提交</button>
        </form>
    </div>

    <script>
        $('#tijiao').click(function () {
            let data = {};
            data['biaoti'] = $('#biaoti').val();
            data['fenlei'] = $('#fenlei').val();
            data['desc'] = $('#desc').val();
            let selectedTags = [];
            $('input[name="tag"]:checked').each(function () {
                selectedTags.push($(this).val());
            });
            data['tag'] = selectedTags;
            data['neirong'] = window.editor.html();
            data['csrfmiddlewaretoken'] = '{{ csrf_token }}';
            console.log(data);
            $.ajax({
                url: '{% url 'backend_add_article' %}',
                type: 'post',
                data: data,
                success: function (args) {
                    if (args.code === 2000) {
                        swal({
                            title: args.msg,
                            icon: "success",
                            button: true,
                        }).then(() => {
                            window.location.reload();
                        });
                    } else {
                        swal({
                            title: args.msg,
                            icon: "error",
                            button: true,
                        }).then(() => {
                            window.location.reload();
                        });
                    }
                }
            });
        });
    </script>
    <script>
        KindEditor.ready(function (K) {
            window.editor = K.create('#article_content', {
                "width": "100%",
                "height": "400px",
                "resizeType": 1,
            });
        });
    </script>
{% endblock %}
```

- backend_category.html

```html
{% extends 'backend.html' %}
{% block backend_right %}
    <div class="col-md-10">
        <ul id="myTabs" class="nav nav-tabs" role="tablist">
            <li role="presentation" class=""><a href="{% url 'backend_add_article' %}" id="add_article" role="tab"
                                                      data-toggle="tab"
                                                      aria-controls="profile" aria-expanded="false">添加文章</a>
            </li>
            <li role="presentation" class=""><a href="{% url 'backend' %}" id="home-tab" role="tab"
                                                data-toggle="tab"
                                                aria-controls="profile" aria-expanded="false">随笔</a></li>
            <li role="presentation" class="active"><a href="{% url 'backend_category' %}" role="tab" id="profile-tab"
                                                      data-toggle="tab"
                                                      aria-controls="categories" aria-expanded="true">分类</a></li>
            <li role="presentation" class=""><a href="{% url 'backend_tag' %}" role="tab" id="profile-tab"
                                                data-toggle="tab"
                                                aria-controls="profile" aria-expanded="false">标签</a></li>
            <li role="presentation" class=""><a href="{% url 'backend_comment' %}" role="tab" id="profile-tab"
                                                data-toggle="tab"
                                                aria-controls="profile" aria-expanded="false">评论</a></li>
        </ul>
        <br>
        <table class="table table-striped">
            <thead>
            <tr>
                <th>文章标题</th>
                <th>分类名称</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                {% for cate_obj in page_queryset %}
                    <td>{{ cate_obj.article__title }}</td>
                    <td>{{ cate_obj.name }}</td>
                    <td>
                        <button class="btn btn-primary btn-xs edit">编辑</button>
                        <button class="btn btn-danger btn-xs delete">删除</button>
                    </td>
                    </tr>
                {% endfor %}
            </tbody>
        </table>
    </div>
    <div class="text-center">{{ page_obj.page_html|safe }}
    </div>
{% endblock %}
```

- backend_comment.html

```html
{% extends 'backend.html' %}
{% block backend_right %}
    <div class="col-md-10">
        <ul id="myTabs" class="nav nav-tabs" role="tablist">
            <li role="presentation" class=""><a href="{% url 'backend_add_article' %}" id="add_article" role="tab"
                                                      data-toggle="tab"
                                                      aria-controls="profile" aria-expanded="false">添加文章</a>
            </li>
            <li role="presentation" class=""><a href="{% url 'backend' %}" id="home-tab" role="tab"
                                                data-toggle="tab"
                                                aria-controls="profile" aria-expanded="false">随笔</a></li>
            <li role="presentation" class=""><a href="{% url 'backend_category' %}" role="tab" id="profile-tab"
                                                data-toggle="tab"
                                                aria-controls="categories" aria-expanded="false">分类</a></li>
            <li role="presentation" class=""><a href="{% url 'backend_tag' %}" role="tab" id="profile-tab"
                                                data-toggle="tab"
                                                aria-controls="tags" aria-expanded="false">标签</a></li>
            <li role="presentation" class="active"><a href="{% url 'backend_comment' %}" role="tab" id="profile-tab"
                                                      data-toggle="tab"
                                                      aria-controls="comments" aria-expanded="true">评论</a></li>
        </ul>
        <br>
        <table class="table table-striped">
            <thead>
            <tr>
                <th>文章名称</th>
                <th>评论内容</th>
                <th>评论时间</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                {% for comment_data in page_queryset %}
                    <td>{{ comment_data.article__title }}</td>
                    <td>{{ comment_data.content }}</td>
                    <td>{{ comment_data.comment_time }}</td>
                    <td>
                        <button class="btn btn-primary btn-xs edit">编辑</button>
                        <button class="btn btn-danger btn-xs delete">删除</button>
                    </td>
                    </tr>
                {% endfor %}
            </tbody>
        </table>
    </div>
    <div class="text-center">{{ page_obj.page_html|safe }}
    </div>
{% endblock %}
```

- backend_tag.html

```html
{% extends 'backend.html' %}
{% block backend_right %}
    <div class="col-md-10">
        <ul id="myTabs" class="nav nav-tabs" role="tablist">
            <li role="presentation" class=""><a href="{% url 'backend_add_article' %}" id="add_article" role="tab"
                                                      data-toggle="tab"
                                                      aria-controls="profile" aria-expanded="false">添加文章</a>
            </li>
            <li role="presentation" class=""><a href="{% url 'backend' %}" id="home-tab" role="tab"
                                                data-toggle="tab"
                                                aria-controls="profile" aria-expanded="false">随笔</a></li>
            <li role="presentation" class=""><a href="{% url 'backend_category' %}" role="tab" id="profile-tab"
                                                data-toggle="tab"
                                                aria-controls="categories" aria-expanded="false">分类</a></li>
            <li role="presentation" class="active"><a href="{% url 'backend_tag' %}" role="tab" id="profile-tab"
                                                      data-toggle="tab"
                                                      aria-controls="tags" aria-expanded="true">标签</a></li>
            <li role="presentation" class=""><a href="{% url 'backend_comment' %}" role="tab" id="profile-tab"
                                                data-toggle="tab"
                                                aria-controls="comments" aria-expanded="false">评论</a></li>
        </ul>
        <br>
        <table class="table table-striped">
            <thead>
            <tr>
                <th>文章名称</th>
                <th>标签名称</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                {% for tag_data in page_queryset %}
                    <td>{{ tag_data.article__title }}</td>
                    <td>{{ tag_data.name }}</td>
                    <td>
                        <button class="btn btn-primary btn-xs edit">编辑</button>
                        <button class="btn btn-danger btn-xs delete">删除</button>
                    </td>
                    </tr>
                {% endfor %}
            </tbody>
        </table>
    </div>
    <div class="text-center">{{ page_obj.page_html|safe }}
    </div>
{% endblock %}
```

# 常用方法

`更新中...`

## 实时渲染头像

```js
<script>
    $('#myfile').change(function () {
        // 文件阅读器对象
        // 1 先生成一个文件阅读器对象
        let myFileReader = new FileReader();
        // 2 获取用户上传的头像文件
        let fileobj = $(this)[0].files[0];
        // 3 将文件对象交给阅读器读取
        myFileReader.readAsDataURL(fileobj); // 异步操作 IO操作
        // 4 当文件阅读器读取完毕后，将读取到的文件内容赋值给img标签
        myFileReader.onload = function () {
            $('#myimg').attr('src', myFileReader.result);
        }
    })
</script>
```

## swal提示框

```js
success: function (args) {
    if (args.code === 2000) {
        swal({
            title: args.msg,
            icon: "success",
            button: true,
        }).then(() => {
            window.location.href = args.url;
        });
    } else {
        swal({
            title: args.msg,
            icon: "error",
            button: true,
        }).then(() => {
            window.location.reload();
        });
    }
}
```

## 上传文件、form表单循环取值

```js
let formData = new FormData();
$.each($('#myform').serializeArray(), function (index, obj) {
    formData.append(obj.name, obj.value);
})
formData.append('adv_img', $('#myfile')[0].files[0]);
$.ajax({
    url: '',
    type: 'post',
    data: formData,
    processData: false,
    contentType: false,
    success: function (args) {
        
    }
```

## 分页器

```python
{{ page_obj.page_html|safe }}
```

```python
current_page = request.GET.get("page", 1)
all_count = article_data.count()
page_obj = Pagination(current_page=current_page, all_count=all_count, per_page_num=5)
page_queryset = article_data[page_obj.start:page_obj.end]
```

```python
# -*- coding: utf-8 -*-
# author : heart
# blog_url : https://www.cnblogs.com/ssrheart/
# time : 2024/3/18

class Pagination(object):
    def __init__(self, current_page, all_count, per_page_num=2, pager_count=11):
        """
        封装分页相关数据
        :param current_page: 当前页
        :param all_count:    数据库中的数据总条数
        :param per_page_num: 每页显示的数据条数
        :param pager_count:  最多显示的页码个数
        """
        try:
            current_page = int(current_page)
        except Exception as e:
            current_page = 1

        if current_page < 1:
            current_page = 1

        self.current_page = current_page

        self.all_count = all_count
        self.per_page_num = per_page_num

        # 总页码
        all_pager, tmp = divmod(all_count, per_page_num)
        if tmp:
            all_pager += 1
        self.all_pager = all_pager

        self.pager_count = pager_count
        self.pager_count_half = int((pager_count - 1) / 2)

    @property
    def start(self):
        return (self.current_page - 1) * self.per_page_num

    @property
    def end(self):
        return self.current_page * self.per_page_num

    def page_html(self):
        # 如果总页码 < 11个：
        if self.all_pager <= self.pager_count:
            pager_start = 1
            pager_end = self.all_pager + 1
        # 总页码  > 11
        else:
            # 当前页如果<=页面上最多显示11/2个页码
            if self.current_page <= self.pager_count_half:
                pager_start = 1
                pager_end = self.pager_count + 1

            # 当前页大于5
            else:
                # 页码翻到最后
                if (self.current_page + self.pager_count_half) > self.all_pager:
                    pager_end = self.all_pager + 1
                    pager_start = self.all_pager - self.pager_count + 1
                else:
                    pager_start = self.current_page - self.pager_count_half
                    pager_end = self.current_page + self.pager_count_half + 1

        page_html_list = []
        # 添加前面的nav和ul标签
        page_html_list.append('''
                    <nav aria-label='Page navigation>'
                    <ul class='pagination'>
                ''')
        first_page = '<li><a href="?page=%s">首页</a></li>' % (1)
        page_html_list.append(first_page)

        if self.current_page <= 1:
            prev_page = '<li class="disabled"><a href="#">上一页</a></li>'
        else:
            prev_page = '<li><a href="?page=%s">上一页</a></li>' % (self.current_page - 1,)

        page_html_list.append(prev_page)

        for i in range(pager_start, pager_end):
            if i == self.current_page:
                temp = '<li class="active"><a href="?page=%s">%s</a></li>' % (i, i,)
            else:
                temp = '<li><a href="?page=%s">%s</a></li>' % (i, i,)
            page_html_list.append(temp)

        if self.current_page >= self.all_pager:
            next_page = '<li class="disabled"><a href="#">下一页</a></li>'
        else:
            next_page = '<li><a href="?page=%s">下一页</a></li>' % (self.current_page + 1,)
        page_html_list.append(next_page)

        last_page = '<li><a href="?page=%s">尾页</a></li>' % (self.all_pager,)
        page_html_list.append(last_page)
        # 尾部添加标签
        page_html_list.append('''
                                           </nav>
                                           </ul>
                                       ''')
        return ''.join(page_html_list)
```

## Django后台UI美化界面

- settings里注册`simpleui`

```python
pip install django-simpleui
```

```python
INSTALLED_APPS = [
    'simpleui',
]
```
