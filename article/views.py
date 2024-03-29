import json

from django.contrib.auth.decorators import login_required
from django.db.models import Count
from django.db.models.functions import TruncMonth
from django.http import JsonResponse
from django.shortcuts import render, redirect, HttpResponse

from article.models import Article, Category, Tag, UpAndDown, Comment
from blog.fenyeqi import Pagination
from blog.models import Blog


# 一篇文章可以有多个标签
# 一个分类可以有多篇文章
# 一个文章只能有一个分类
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

