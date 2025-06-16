import 'package:wallix_app/Model/categories_model.dart';

String apiKey = "WoUYKE2qZSyf4dCazVkPkQZSqkhEmWiIQHwR0UtPzHNDEdYtxJRmDEWr";

List<CategoriesModel> getCategories() {

  List<CategoriesModel> categories = [];
  CategoriesModel categoriesModel = CategoriesModel();

  categoriesModel.imgUrl =
      "https://images.pexels.com/photos/1181676/pexels-photo-1181676.jpeg?cs=srgb&dl=pexels-divinetechygirl-1181676.jpg&fm=jpg";
  categoriesModel.categoriesName = "Coding";
  categories.add(categoriesModel);
  categoriesModel = CategoriesModel();  // Resetting the model for next category


  categoriesModel.imgUrl =
      "https://images.pexels.com/photos/2119706/pexels-photo-2119706.jpeg?cs=srgb&dl=pexels-tobiasbjorkli-2119706.jpg&fm=jpg";
  categoriesModel.categoriesName = "Street Art";
  categories.add(categoriesModel);
  categoriesModel = CategoriesModel();

  categoriesModel.imgUrl =
      "https://images.pexels.com/photos/46254/leopard-wildcat-big-cat-botswana-46254.jpeg?cs=srgb&dl=pexels-pixabay-46254.jpg&fm=jpg";
  categoriesModel.categoriesName = "Wild Life";
  categories.add(categoriesModel);
  categoriesModel = CategoriesModel();

  categoriesModel.imgUrl =
      "https://images.pexels.com/photos/147411/italy-mountains-dawn-daybreak-147411.jpeg?cs=srgb&dl=pexels-pixabay-147411.jpg&fm=jpg";
  categoriesModel.categoriesName = "Nature";
  categories.add(categoriesModel);
  categoriesModel = CategoriesModel();

  categoriesModel.imgUrl =
      "https://images.pexels.com/photos/169647/pexels-photo-169647.jpeg?cs=srgb&dl=pexels-peng-liu-45946-169647.jpg&fm=jpg";
  categoriesModel.categoriesName = "City";
  categories.add(categoriesModel);
  categoriesModel = CategoriesModel();

  categoriesModel.imgUrl =
      "https://images.pexels.com/photos/2740956/pexels-photo-2740956.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500";
  categoriesModel.categoriesName = "Motivation";
  categories.add(categoriesModel);
  categoriesModel = CategoriesModel();

  categoriesModel.imgUrl =
      "https://images.pexels.com/photos/1119796/pexels-photo-1119796.jpeg?cs=srgb&dl=pexels-vikramstudio46-1119796.jpg&fm=jpg";
  categoriesModel.categoriesName = "Bikes";
  categories.add(categoriesModel);
  categoriesModel = CategoriesModel();

  categoriesModel.imgUrl =
      "https://images.pexels.com/photos/210019/pexels-photo-210019.jpeg?cs=srgb&dl=pexels-pixabay-210019.jpg&fm=jpg";
  categoriesModel.categoriesName = "Cars";
  categories.add(categoriesModel);
  categoriesModel = CategoriesModel();

  return categories;
}
