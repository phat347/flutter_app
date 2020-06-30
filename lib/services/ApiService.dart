import 'package:dio/dio.dart';
import 'package:flutterapp/models/Submission.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';


part 'ApiService.g.dart';
@RestApi(baseUrl: "https://next.json-generator.com")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  static ApiService create(){
    final dio = new Dio();
    dio.interceptors.add(PrettyDioLogger());
    return ApiService(dio);
  }
  @GET("/api/json/get/41TUyej6d")
  Future<Submission> getDetailSubmission();

  @GET("/api/json/get/VJAAA4TT_")
  Future<List<Submission>> getListSubmission();

  @GET("/api/json/get/EyGudVOhu")
  Future<List<Submission>> getListSpecialSubmission();

  @GET("/api/json/get/VJjJ8zx0_")
  Future<List<Submission>> getRecommenderSubmission();

  @GET("/api/json/get/EyGudVOhu")
  Future<List<Submission>> getRecommenderSubmissionDistance();


}