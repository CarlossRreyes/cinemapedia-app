

import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';

class ActorMapper {

  static Actor castToEntity( Cast cast) => 
    Actor(
        id: cast.id,
        name: cast.name,
        profilePath: cast.profilePath != null 
        ? "https://image.tmdb.org/t/p/w500${ cast.profilePath }"
        : "https://wakaw.ca/wp-content/uploads/2020/11/facebook-default-no-profile-pic-300x300-1.jpg",
        character: cast.character
    );
}