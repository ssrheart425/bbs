import os.path

from django.http import JsonResponse
from django.shortcuts import render, HttpResponse, redirect
from django.contrib.auth.decorators import login_required
from blog import models
from blog.fenyeqi import Pagination
from article import models as article_models
from user.models import UserInfo


def index(request):
    adv_data = models.Adv.objects.all()
    article_data = article_models.Article.objects.all()
    current_page = request.GET.get("page", 1)
    all_count = article_data.count()
    page_obj = Pagination(current_page=current_page, all_count=all_count, per_page_num=5)
    page_queryset = article_data[page_obj.start:page_obj.end]
    cebian_gg = models.Adv.objects.all()[:3]
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


def edit_adv(request):
    back_dic = {'code': 2000, 'msg': '修改成功!', 'url': ''}
    avatar_obj = UserInfo.objects.filter(username=request.user).values(
        'avatar'
    )
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
