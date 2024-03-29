# -*- coding: utf-8 -*-
# author : heart
# blog_url : https://www.cnblogs.com/ssrheart/
# time : 2024/3/13
from django.urls import path
from blog import views
urlpatterns = [
    path('index/', views.index, name='index'),
    path('change_password/', views.change_password, name='change_password'),
    path('adv/', views.adv, name='adv'),
    path('edit_adv/', views.edit_adv, name='edit_adv'),
]