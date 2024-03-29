from django.contrib import admin

# Register your models here.
from blog.models import Blog,Adv

@admin.register(Blog)
class BlogAdmin(admin.ModelAdmin):
    list_display = ['site_name','site_title','site_theme']

@admin.register(Adv)
class AdvAdmin(admin.ModelAdmin):
    list_display = ['title','content','create_time','update_time','mobile','img']