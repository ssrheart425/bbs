from django.contrib import admin

# Register your models here.
from article.models import Category, Tag, Comment, UpAndDown, Article, Article2Tag


@admin.register(Article)
class ArticleAdmin(admin.ModelAdmin):
    ordering = ["id"]

    def display_content(self, obj):
        return obj.content[:20]

    def display_desc(self, obj):
        return obj.desc[:10]

    display_content.short_description = "文章内容"
    display_desc.short_description = "文章摘要"

    list_display = ['id', 'title', 'display_desc', 'up_num', 'up_down', 'comment_num', 'display_content',
                    'create_time', 'blog', 'category']


@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ['name', 'blog']


@admin.register(Tag)
class TagAdmin(admin.ModelAdmin):
    list_display = ['name', 'blog']


@admin.register(Article2Tag)
class Article2TagAdmin(admin.ModelAdmin):
    list_display = ['article', 'tag']


@admin.register(UpAndDown)
class UpAndDownAdmin(admin.ModelAdmin):
    list_display = ['user', 'article', 'is_up']


@admin.register(Comment)
class CommentAdmin(admin.ModelAdmin):
    list_display = ['user', 'article', 'content', 'comment_time', 'parent']