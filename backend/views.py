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
