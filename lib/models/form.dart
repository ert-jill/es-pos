import 'dart:convert';

class UserFormModel {
  late String? userName;
  late String? password;
  late String? email;
  late String? firstName;
  late String? lastName;
  late String? userType;
  late String? userAccount;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (userName != null) json['username'] = userName;
    if (password != null) json['password'] = password;
    if (email != null) json['email'] = email;
    if (firstName != null) json['first_name'] = firstName;
    if (lastName != null) json['last_name'] = lastName;
    if (userType != null) json['user_type'] = userType;
    if (userAccount != null) json['user_account'] = userAccount;
    return json;
  }
}

class AccountFormModel {
  String? id;
  String? name;
  String? ownerName;
  String? email;
  String? contactNumber;
  String? address;
  bool? status;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id!;
    if (name != null) data['name'] = name!;
    if (ownerName != null) data['ownerName'] = ownerName!;
    if (email != null) data['email'] = email!;
    if (contactNumber != null) data['contactNumber'] = contactNumber!;
    if (address != null) data['address'] = address!;
    if (status != null) data['status'] = status!;
    return data;
  }
}

class UserTypeFormModel {
  String? id;
  String? name;
  String? description;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id!;
    if (name != null) data['name'] = name!;
    if (description != null) data['description'] = description!;
    return data;
  }
}

class ClassificationFormModel {
  String? id;
  String? name;
  String? description;
  String? parent;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id!;
    if (name != null) data['name'] = name!;
    if (description != null) data['description'] = description!;
    if (description != null) data['parent'] = parent!;

    return data;
  }
}

class DiscountFormModel {
  String? id;
  String? name;
  String? code;
  String? description;
  String? amount;
  String? amountType;
  String? expiryDate;
  String? discountedProduct;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (name != null) data['name'] = name;
    if (code != null) data['code'] = code;
    if (description != null) data['description'] = description;
    if (amount != null) data['amount'] = amount;
    if (amountType != null) data['amount_type'] = amountType;
    if (expiryDate != null) data['expiry_date'] = expiryDate;
    if (discountedProduct != null)
      data['discounted_roduct'] = discountedProduct;
    return data;
  }
}

class ProductGroupItemFormModel {
  String? sku;
  String? quantity;
  String? price;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (sku != null) data['sku'] = sku;
    if (quantity != null) data['quantity'] = quantity;
    if (price != null) data['price'] = price;
    return data;
  }
}

class ProductFormModel {
  String? id;
  String? name;
  String? sku;
  String? description;
  String? price;
  int? stocks;
  List<ProductGroupItemFormModel>? productItems;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (name != null) data['name'] = name;
    if (sku != null) data['sku'] = sku;
    if (description != null) data['description'] = description;
    if (price != null) data['price'] = price;
    if (stocks != null) data['stocks'] = stocks;
    if (productItems != null && productItems!.isNotEmpty)
      data['product_items'] = jsonDecode(jsonEncode(productItems));
    return data;
  }
}

class PaymentMethodFormModel {
  String? id;
  String? name;
  String? type;
  String? description;
  String? accountNumber;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;
    if (accountNumber != null) data['account_number'] = accountNumber;
    if (type != null) data['type'] = type;
    return data;
  }
}

class AreaFormModel {
  String? id;
  String? name;
  String? code;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (name != null) data['name'] = name;
    if (code != null) data['code'] = code;
    return data;
  }
}

class TableFormModel {
  String? id;
  String? name;
  String? code;
  String? area;
  String? isActive;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (name != null) data['name'] = name;
    if (code != null) data['code'] = code;
    if (area != null) data['area'] = area;
    return data;
  }
}

class PrinterFormModel {
  String? id;
  String? name;
  String? connection;
  String? description;
  String? isActive;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (name != null) data['name'] = name;
    if (connection != null) data['connection'] = connection;
    if (description != null) data['description'] = description;
    if (isActive != null) data['is_active'] = isActive;
    return data;
  }
}
