from django.db import models


class CourseInstructors(models.Model):
    course = models.ForeignKey('Courses', models.DO_NOTHING, primary_key=False)
    instructor = models.ForeignKey('Instructors', models.DO_NOTHING, primary_key=False)

    class Meta:
        managed = False
        db_table = 'course_instructors'
        unique_together = (('course', 'instructor'),)


class Courses(models.Model):
    course_id = models.IntegerField(primary_key=True)
    course_name = models.CharField(max_length=100, blank=True, null=True)
    credits = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'courses'


class Enrollments(models.Model):
    student = models.ForeignKey('Students', models.DO_NOTHING)
    course = models.ForeignKey('Courses', models.DO_NOTHING)
    enroll_date = models.DateField(blank=True, null=True)
    grade = models.CharField(max_length=1, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'enrollments'
        unique_together = (('student', 'course'),)



class Instructors(models.Model):
    instructor_id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=100, blank=True, null=True)
    department = models.CharField(max_length=100, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'instructors'


class Students(models.Model):
    student_id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=100, blank=True, null=True)
    dob = models.DateField(blank=True, null=True)
    email = models.CharField(max_length=100, blank=True, null=True)
    gpa = models.DecimalField(max_digits=3, decimal_places=2, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'students'

