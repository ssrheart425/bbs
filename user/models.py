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
