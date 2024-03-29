from django.contrib import admin

# Register your models here.
from user.models import UserInfo
from django.utils.html import format_html
@admin.register(UserInfo)
class UserInfoAdmin(admin.ModelAdmin):
    ordering = ['id']

    # 想要对某个字段进行额外的处理渲染指定的样式 需要重写一个函数
    def display_avatar(self, obj):
        # 获取默认的avatar路径
        avatar_path = obj.avatar if obj.avatar else 'static/avatar/default.png'
        # 拼接完整的URL
        avatar_url = f'http://127.0.0.1:8000/media/{avatar_path}'

        return format_html(
            f'<a href="{avatar_url}" target="_blank">'
            f'<img src="{avatar_url}"  alt="请稍后再试哦" style="width: 50px;height: auto">'
            f'</a>')

    display_avatar.short_description = "用户头像"
    list_display = ['id', 'username', 'is_superuser', 'email', 'phone', 'display_avatar', 'create_time', 'is_deleted','blog']
