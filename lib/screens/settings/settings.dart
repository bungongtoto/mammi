import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _showToggle = false;
  late String _shopName;
  XFile? _profileImage; // Nullable XFile type
  String? _shopId;

  @override
  void initState() {
    super.initState();
    _fetchShopData();
  }

  void _fetchShopData() async {
    final user = FirebaseAuth.instance.currentUser;
    final shopDocs = await FirebaseFirestore.instance.collection('shops').where('userId', isEqualTo: user!.uid).get();
    if (shopDocs.docs.isNotEmpty) {
      final shopData = shopDocs.docs.first.data() as Map<String, dynamic>;
      final shopId = shopDocs.docs.first.id;
      setState(() {
        _showToggle = false;
        _shopId = shopId;
        _shopName = shopData['name'] ?? '';
      });
    } else {
      setState(() {
        _showToggle = true;
        _shopId = null;
      });
    }
  }

  void _toggleSetting(bool value) {
    if (value) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmation'),
            content: const Text('Are you sure you want to become a shop?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _updateSetting(value);
                  _createShopDocument();
                },
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      );
    } else {
      _updateSetting(value);
      if (_shopId != null) {
        _deleteShopDocument(_shopId!);
      }
    }
  }

  void _updateSetting(bool value) {
    setState(() {
      _showToggle = value;
    });
  }

  void _createShopDocument() {
    final user = FirebaseAuth.instance.currentUser;
    final shopData = {
      'userId': user!.uid,
      'name': _shopName,
      'imageUrl': _profileImage?.path ?? '',
    };
    FirebaseFirestore.instance.collection('shops').add(shopData);
  }

  void _updateShopDocument(String shopId) {
    final shopData = {
      'name': _shopName,
      'imageUrl': _profileImage?.path ?? '',
    };
    FirebaseFirestore.instance.collection('shops').doc(shopId).update(shopData);
  }

  void _deleteShopDocument(String shopId) {
    FirebaseFirestore.instance.collection('shops').doc(shopId).delete();
  }

  void _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Show Toggle',
                style: Theme.of(context).textTheme.headline6!,
              ),
              if (_showToggle)
                SwitchListTile(
                  title: const Text('Become a Shop'),
                  value: _showToggle,
                  onChanged: _toggleSetting,
                ),
              const SizedBox(height: 16),
              Text(
                'Profile Picture:',
                style: Theme.of(context).textTheme.subtitle1!,
              ),
              InkWell(
                onTap: _showToggle ? _pickProfileImage : null,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _profileImage != null ? FileImage(File(_profileImage!.path)) : null,
                  child: _profileImage == null
                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Shop Name:',
                style: Theme.of(context).textTheme.subtitle1!,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter shop name',
                ),
                onChanged: (value) {
                  _shopName = value;
                },
                enabled: _showToggle,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _showToggle
                    ? () {
                        if (_shopId != null) {
                          _updateShopDocument(_shopId!);
                        } else {
                          _createShopDocument();
                        }
                      }
                    : null,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
