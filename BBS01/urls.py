from django.contrib import admin
from django.urls import path, include, re_path
from user import urls as user_urls
from blog import urls as blog_urls
from article import urls as article_urls
from backend import urls as backend_urls
from article.views import article_detail
from blog import views as blog_index_views
from BBS01 import settings
from django.views.static import serve
from article.views import site
urlpatterns = [
    path('admin/', admin.site.urls, name='admin'),
    path('', blog_index_views.index, name='index'),
    path('user/', include(user_urls)),
    path('blog/', include(blog_urls)),
    path('article/', include(article_urls)),
    path('backend/', include(backend_urls)),

    path('<slug:username>/article/<int:pk>/', article_detail,name='article_detail'),
    re_path('media/(?P<path>.*)', serve, {'document_root': settings.MEDIA_ROOT}),
    path('<slug:username>/', site, name='site'),
    re_path(r"^(?P<username>\w+)/(?P<condition>category|tag|archive)/(?P<param>.*)/$", site, name="article_left"),
]
