# -*- coding: utf-8 -*-
# author : heart
# blog_url : https://www.cnblogs.com/ssrheart/
# time : 2024/3/13
from django.urls import path, re_path
from article import views

urlpatterns = [
    path('up_down/', views.up_down, name='up_down'),
    path('comment/', views.comment, name='comment'),
]
