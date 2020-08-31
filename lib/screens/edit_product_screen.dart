import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeNameEdit = '/edit-product-screen';
  static const routeNameCreate = '/create-product-screen';
  final isEditProductMode;

  EditProductScreen({this.isEditProductMode});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // zmiana focusa na kolejny textField
  final _priceFocusNode = FocusNode();
  final _decsFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  final _imageUrlController = TextEditingController();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  // Umożliwia odwoływanie się do State podpiętego widgeta poza WidgetTree
  final _form = GlobalKey<FormState>();

  String editedProductId = '';
  bool _isLoading = false;
  bool _isInit = false;

  @override
  void initState() {
    super.initState();

    // myk pozwala na wyzwolenie akcji na utrate focusa
    _imageUrlFocusNode.addListener(updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.isEditProductMode && !_isInit) {
      Product product = ModalRoute.of(context).settings.arguments as Product;
      editedProductId = product.id;
      _titleController.text = product.title;
      _priceController.text = product.price.toStringAsFixed(2);
      _descController.text = product.description;
      _imageUrlController.text = product.imageUrl;

      _isInit = true;
    }
  }

  void updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus &&
        urlImageValidation(_imageUrlController.text) == null) {
      setState(() {});
    }
  }

  void _saveForm() {
    _form.currentState.save();

    final isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want end edit and save?'),
              actions: [
                FlatButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    }),
                FlatButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    }),
              ]);
        }).then((value) {
      if (value) {
        Product product = Product(
            id: editedProductId.isNotEmpty && widget.isEditProductMode
                ? editedProductId
                : DateTime.now().toString(),
            title: _titleController.text,
            price: double.parse(_priceController.text),
            description: _descController.text,
            imageUrl: _imageUrlController.text);

        var productsData = Provider.of<Products>(context, listen: false);

        if (widget.isEditProductMode) {
          productsData.updateProduct(product).catchError((error) {
            return showCatchErrorDialog();
          }).then((_) {
            Navigator.of(context).pop();

            setState(() {
              _isLoading = false;
            });
          });
        } else {
          productsData.addProduct(product).catchError((error) {
            return showCatchErrorDialog();
          }).then((_) {
            Navigator.of(context).pop();

            setState(() {
              _isLoading = false;
            });
          });
        }
      }
    });
  }

  Future<Null> showCatchErrorDialog() {
    return showDialog<Null>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('An error occured!'),
            content: Text('Something went wrong'),
            actions: [
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          );
        });
  }

  String textValidate(String value) {
    if (value.isEmpty) {
      // komuniat obłędzie
      return 'Please provide a value';
    }

    // brak komunikatu o błędzie
    return null;
  }

  String priceValidate(String value) {
    if (value.isEmpty ||
        double.parse(value) == null ||
        double.parse(value) <= 0) {
      return 'Please provide a number grater than 0.00';
    }

    return null;
  }

  String urlImageValidation(String value) {
    if (!value.startsWith('http') && !value.startsWith('https')) {
      return 'Please enter a vald URL';
    }

    if (!value.endsWith('png') &&
        !value.endsWith('jpg') &&
        !value.startsWith('jpeg')) {
      return 'Please enter a vald image URL';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isEditProductMode ? 'Edit Product' : 'Add New Product'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: ListView(children: [
                    TextFormField(
                        controller: _titleController,
                        validator: (value) => textValidate(value),
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        }),
                    TextFormField(
                        controller: _priceController,
                        validator: (value) => priceValidate(value),
                        decoration: InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_decsFocusNode);
                        }),
                    TextFormField(
                      controller: _descController,
                      validator: (value) => textValidate(value),
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _decsFocusNode,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              validator: (value) => urlImageValidation(value),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              }),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, left: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: Container(
                            child: _imageUrlController.text.isEmpty
                                ? Center(
                                    child: Icon(
                                    Icons.photo_size_select_actual,
                                    color: Colors.grey,
                                    size: 50,
                                  ))
                                : FittedBox(
                                    child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  )),
                          ),
                        ),
                      ],
                    )
                  ])),
            ),
    );
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _decsFocusNode.dispose();
    _imageUrlFocusNode.dispose();

    _imageUrlController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _titleController.dispose();
    super.dispose();
  }
}
