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
