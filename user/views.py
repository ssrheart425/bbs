from django.http import JsonResponse, HttpResponse
from django.shortcuts import render, redirect
from user.MyForms import MyRegForm
from user import models
from django.contrib import auth
from PIL import Image, ImageDraw, ImageFont
from io import BytesIO, StringIO
import random
from django.urls import reverse


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
            back_dic['url'] = '/user/login/'
        else:
            back_dic['code'] = 2000
            back_dic['msg'] = form_obj.errors
        return JsonResponse(back_dic)
    return render(request, 'register.html', locals())  # 返回一个html页面


def login(request):
    if request.method == 'POST':

        data = request.POST
        username = data.get('username')
        password = data.get('password')
        code = data.get('code')
        back_dict = {'code': 1000, 'msg': f'用户{username}登陆成功!'}
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

    return render(request, 'login.html', locals())


def logout(request):
    if request.method == 'POST':
        request.session.flush()
        return render(request, 'login.html', locals())
    return render(request, 'login.html', locals())


def get_random():
    return random.randint(0, 255), random.randint(0, 255), random.randint(0, 255)


def get_code(request):
    # 方式四：动态生成验证码图片
    img_obj = Image.new('RGB', (430, 35), get_random())
    img_draw = ImageDraw.Draw(img_obj)  # 产生一个画笔对象
    img_font = ImageFont.truetype("static/font/春联标准行书体.ttf", 30)

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


