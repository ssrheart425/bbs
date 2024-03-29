# -*- coding: utf-8 -*-
# author : heart
# blog_url : https://www.cnblogs.com/ssrheart/
# time : 2024/3/13
from django.urls import path
from user import views
urlpatterns = [
    path('register/',views.register, name='register'),
    path('login/',views.login, name='login'),
    path('get_code/',views.get_code, name='get_code'),
    path('logout/', views.logout, name='logout'),
]