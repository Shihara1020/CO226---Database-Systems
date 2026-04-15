from django.contrib import admin

from django.contrib import admin
from .models import Students, Courses, Enrollments, Instructors,CourseInstructors
admin.site.register(Students)
admin.site.register(Courses)
admin.site.register(Enrollments)
admin.site.register(Instructors)
admin.site.register(CourseInstructors)
