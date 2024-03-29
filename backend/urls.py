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
