from django.db import models


class Category(models.Model):
    name = models.CharField(max_length=32, verbose_name='文章分类', help_text='这是文章分类')
    blog = models.ForeignKey(to='blog.Blog', on_delete=models.CASCADE, null=True)

    def __str__(self):
        return self.name


class Tag(models.Model):
    name = models.CharField(max_length=32, verbose_name='文章标签', help_text='这是文章标签')
    blog = models.ForeignKey(to='blog.Blog', on_delete=models.CASCADE, null=True)

    def __str__(self):
        return self.name


class Article(models.Model):
    title = models.CharField(max_length=64, verbose_name='文章标题', help_text='这是文章标题')
    desc = models.CharField(max_length=255, verbose_name='文章简介', help_text='这是文章简介')
    content = models.TextField(verbose_name='文章内容', help_text='这是文章内容')
    create_time = models.DateField(auto_now_add=True, verbose_name='创建时间', help_text='这是创建时间')

    up_num = models.BigIntegerField(default=0, verbose_name='点赞数', help_text='这是点赞数')
    up_down = models.BigIntegerField(default=0, verbose_name='点踩数', help_text='这是点踩数')
    comment_num = models.BigIntegerField(default=0, verbose_name='评论数', help_text='这是评论数')

    blog = models.ForeignKey(to='blog.Blog', on_delete=models.CASCADE, null=True)
    category = models.ForeignKey(to='Category', on_delete=models.CASCADE, null=True)
    tags = models.ManyToManyField(to='Tag', through='Article2Tag', through_fields=('article', 'tag'))

    def __str__(self):
        return self.title


class Article2Tag(models.Model):
    article = models.ForeignKey(to='Article', on_delete=models.CASCADE)
    tag = models.ForeignKey(to='Tag', on_delete=models.CASCADE)


class UpAndDown(models.Model):
    user = models.ForeignKey(to='user.UserInfo', on_delete=models.CASCADE)
    article = models.ForeignKey(to='Article', on_delete=models.CASCADE)
    is_up = models.BooleanField(verbose_name='是否点赞', help_text='这是是否点赞')


class Comment(models.Model):
    user = models.ForeignKey(to='user.UserInfo', on_delete=models.CASCADE)
    article = models.ForeignKey(to='Article', on_delete=models.CASCADE)
    content = models.CharField(max_length=255, verbose_name='评论内容', help_text='这是评论内容')
    comment_time = models.DateTimeField(auto_now_add=True, verbose_name='评论时间', help_text='这是评论时间')
    parent = models.ForeignKey(to='self', on_delete=models.CASCADE, null=True, blank=True, verbose_name='父评论',
                               help_text='这是父评论')
