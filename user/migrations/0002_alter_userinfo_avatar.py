# Generated by Django 3.2.12 on 2024-03-13 08:58

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('user', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='userinfo',
            name='avatar',
            field=models.FileField(default='avatar/default.png', help_text='这是用户头像', upload_to='avatar/', verbose_name='用户头像'),
        ),
    ]