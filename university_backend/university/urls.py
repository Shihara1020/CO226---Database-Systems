from django.urls import path
from . import views
urlpatterns = [
    path('students/', views.student_list),
    path('courses/', views.course_list, name='course_list'),

]