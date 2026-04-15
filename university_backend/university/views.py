from django.shortcuts import render
from django.http import JsonResponse
from .models import Students
from .models import Courses

def student_list(request):
    students = list(Students.objects.values())
    return JsonResponse(students, safe=False)

def course_list(request):
    courses = list(Courses.objects.values())  
    return JsonResponse(courses, safe=False)