/****************************************************************************
** Meta object code from reading C++ file 'blobprovider.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.11.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../react-native-desktop/ReactQt/runtime/src/blobprovider.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'blobprovider.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.11.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_BlobProvider_t {
    QByteArrayData data[6];
    char stringdata0[81];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_BlobProvider_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_BlobProvider_t qt_meta_stringdata_BlobProvider = {
    {
QT_MOC_LITERAL(0, 0, 12), // "BlobProvider"
QT_MOC_LITERAL(1, 13, 17), // "enableBlobSupport"
QT_MOC_LITERAL(2, 31, 0), // ""
QT_MOC_LITERAL(3, 32, 8), // "socketId"
QT_MOC_LITERAL(4, 41, 18), // "disableBlobSupport"
QT_MOC_LITERAL(5, 60, 20) // "addNetworkingHandler"

    },
    "BlobProvider\0enableBlobSupport\0\0"
    "socketId\0disableBlobSupport\0"
    "addNetworkingHandler"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_BlobProvider[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       3,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // methods: name, argc, parameters, tag, flags
       1,    1,   29,    2, 0x02 /* Public */,
       4,    1,   32,    2, 0x02 /* Public */,
       5,    0,   35,    2, 0x02 /* Public */,

 // methods: parameters
    QMetaType::Void, QMetaType::LongLong,    3,
    QMetaType::Void, QMetaType::LongLong,    3,
    QMetaType::Void,

       0        // eod
};

void BlobProvider::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        BlobProvider *_t = static_cast<BlobProvider *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->enableBlobSupport((*reinterpret_cast< qlonglong(*)>(_a[1]))); break;
        case 1: _t->disableBlobSupport((*reinterpret_cast< qlonglong(*)>(_a[1]))); break;
        case 2: _t->addNetworkingHandler(); break;
        default: ;
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject BlobProvider::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_BlobProvider.data,
      qt_meta_data_BlobProvider,  qt_static_metacall, nullptr, nullptr}
};


const QMetaObject *BlobProvider::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *BlobProvider::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_BlobProvider.stringdata0))
        return static_cast<void*>(this);
    if (!strcmp(_clname, "ModuleInterface"))
        return static_cast< ModuleInterface*>(this);
    if (!strcmp(_clname, "com.canonical.ReactNative.ModuleInterface"))
        return static_cast< ModuleInterface*>(this);
    return QObject::qt_metacast(_clname);
}

int BlobProvider::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 3)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 3;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 3)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 3;
    }
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
