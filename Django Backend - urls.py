from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from rest_framework import permissions
from rest_framework.routers import DefaultRouter
from drf_yasg.views import get_schema_view
from drf_yasg import openapi
from trips import views

# API Router
router = DefaultRouter()
router.register(r'trips', views.TripViewSet, basename='trip')
router.register(r'itinerary-items', views.ItineraryItemViewSet, basename='itinerary')
router.register(r'polls', views.PollViewSet, basename='poll')
router.register(r'chat-messages', views.ChatMessageViewSet, basename='chat')
router.register(r'expenses', views.ExpenseViewSet, basename='expense')

# Swagger/OpenAPI Schema
schema_view = get_schema_view(
   openapi.Info(
      title="Trip Planner API",
      default_version='v1',
      description="Smart Trip Planner REST API Documentation",
      terms_of_service="https://www.tripplanner.com/terms/",
      contact=openapi.Contact(email="contact@tripplanner.com"),
      license=openapi.License(name="MIT License"),
   ),
   public=True,
   permission_classes=(permissions.AllowAny,),
)

urlpatterns = [
    # Admin
    path('admin/', admin.site.urls),
    
    # API Documentation
    path('swagger/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
    path('redoc/', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),
    path('swagger.json', schema_view.without_ui(cache_timeout=0), name='schema-json'),
    
    # Auth endpoints
    path('api/auth/register/', views.register, name='register'),
    path('api/auth/login/', views.login, name='login'),
    path('api/auth/profile/', views.user_profile, name='profile'),
    
    # JWT Token endpoints
    path('api/token/', include('rest_framework_simplejwt.urls')),
    
    # API endpoints
    path('api/', include(router.urls)),
    
    # Health check
    path('api/health/', lambda request: JsonResponse({'status': 'ok'})),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)