import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:v_safe/db/db_services.dart';
import 'package:v_safe/model/contact_model.dart';
import 'package:v_safe/utils/constants.dart';

class ContactScreen extends StatefulWidget {
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<Contact> contacts = [];
  List<Contact> contactsFilter = [];
  DataBaseHelper _dataBaseHelper = DataBaseHelper();

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    askPermissions();
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  filterContacts() {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);

    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((element) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String contactName = element.displayName!.toLowerCase();
        bool nameMatch = contactName.contains(searchTerm);

        if (nameMatch == true) {
          return true;
        }
        if (searchTermFlatten.isEmpty) {
          return false;
        }
        var phone = element.phones!.firstWhere((element) {
          String phoneFlattered = flattenPhoneNumber(element.value!);
          return phoneFlattered.contains(searchTermFlatten);
        });
        return phone.value != null;
      });
    }
    setState(() {
      contactsFilter = _contacts;
    });
  }

  Future<void> askPermissions() async {
    PermissionStatus permissionStatus = await getContactPermissions();
    if (permissionStatus == PermissionStatus.granted) {
      getAllContacts();
      searchController.addListener(() {
        filterContacts();
      });
    } else {
      handleInvalidPermission(permissionStatus);
    }
  }

// function to get contact permission
  Future<PermissionStatus> getContactPermissions() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  handleInvalidPermission(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      showAlertDialogueBox(
          context, "Access to the contacts denied by the user");
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      showAlertDialogueBox(
          context, "May contact does not exist in this device");
    }
  }

  getAllContacts() async {
    List<Contact> _contacts = await ContactsService.getContacts(
      withThumbnails: false
    );
    setState(() {
      contacts = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool listItemExist = (contactsFilter.length > 0 || contacts.length > 0);

    return Scaffold(
      body: contacts.length == 0
          ? Container(
              decoration: BoxDecoration(
                color: Color(0xfff9d2cf).withOpacity(0.5),
              ),
              child: Center(child: CircularProgressIndicator()))
          : SafeArea(
              child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xfff9d2cf).withOpacity(0.5),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          autofocus: true,
                          controller: searchController,
                          decoration: InputDecoration(
                            labelText: "Search contact",
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      listItemExist == true
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: isSearching == true
                                    ? contactsFilter.length
                                    : contacts.length,
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  Contact contact = isSearching == true
                                      ? contactsFilter[index]
                                      : contacts[index];
                                  return ListTile(
                                    title: Text(contact.displayName!),
                                    leading: contact.avatar != null &&
                                            contact.avatar!.isNotEmpty
                                        ? CircleAvatar(
                                            backgroundColor:
                                                Color(0xff401793),
                                            backgroundImage:
                                                MemoryImage(contact.avatar!),
                                          )
                                        : CircleAvatar(
                                            backgroundColor:
                                                Color(0xff401793),
                                            child: Text(contact.initials()),
                                          ),

                                    onTap: (){
                                      if (contact.phones!.length > 0) {
                                        final String phoneNumber = contact.phones!.elementAt(0).value!;
                                        final String name = contact.displayName!;
                                        _addContact(TContactModel(phoneNumber, name));
                                      } else {
                                        Fluttertoast.showToast(msg: "Oops! Phone number of this contact doesn't exist");
                                      }
                                    },
                                  );
                                },
                              ),
                            )
                          : Container(
                              child: Text("Searching..."),
                            ),
                    ],
                  )),
            ),
    );
  }

  void _addContact(TContactModel newContact) async{
    int result = await _dataBaseHelper.insertContact(newContact);
    if(result != 0){
      Fluttertoast.showToast(msg: "Contact added in trusted contact list");
    } else {
      Fluttertoast.showToast(msg: "Failed to add contact!");
    }
    Navigator.of(context).pop(true);
  }

}
