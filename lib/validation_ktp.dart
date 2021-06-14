class Validation {
  String validateUsername(String value) {
    if (value.isEmpty) {
      return 'Username harus diisi'; //MAKA PESAN DITAMPILKAN
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.length < 3) {
      return 'Password minimal 3 karakter'; //MAKA PESAN DITAMPILKAN
    }
    return null;
  }

  // FUNGSI validatePassword > NAMA FUNGSI BEBAS
  String validateJk(String value) {
    //MENERIMA VALUE DENGAN TYPE STRING
    if (value.length < 1) {
      //VALUE TERSEBUT DI CEK APABILA KURANG DARI 6 KARAKTER
      return 'Gender harus diisi'; //MAKA ERROR AKAN DITAMPILKAN
    }
    return null; //SELAIN ITU LOLOS VALIDASI
  }

  String validateAlamat(String value) {
    if (value.isEmpty) {
      //if (!value.contains('@')) {
      //JIKA VALUE MENGANDUNG KARAKTER @
      return 'Alamat harus diisi'; //MAKA PESAN DITAMPILKAN
    }
    return null;
  }

  String validateName(String value) {
    if (value.isEmpty) {
      //JIKA VALUE KOSONG
      return 'Nama Lengkap Harus Diisi'; //MAKA PESAN DITAMPILKAN
    }
    return null;
  }

  String validateNik(String value) {
    if (value.isEmpty) {
      //JIKA VALUE KOSONG
      return 'NIK Harus Diisi'; //MAKA PESAN DITAMPILKAN
    }
    return null;
  }

  String validateTempatLahir(String value) {
    if (value.isEmpty) {
      //JIKA VALUE KOSONG
      return 'Tempat lahir Harus Diisi'; //MAKA PESAN DITAMPILKAN
    }
    return null;
  }

  String validateTglLahir(String value) {
    if (value.isEmpty) {
      //JIKA VALUE KOSONG
      return 'Format: dd-mm-yyyy'; //MAKA PESAN DITAMPILKAN
    }
    return null;
  }

  String validateRT(String value) {
    if (value.isEmpty) {
      //JIKA VALUE KOSONG
      return 'RT Harus Diisi'; //MAKA PESAN DITAMPILKAN
    }
    return null;
  }

  String validateRW(String value) {
    if (value.isEmpty) {
      //JIKA VALUE KOSONG
      return 'RT Harus Diisi'; //MAKA PESAN DITAMPILKAN
    }
    return null;
  }

  String validateKelurahan(String value) {
    if (value.isEmpty) {
      //JIKA VALUE KOSONG
      return 'Kelurahan Harus Diisi'; //MAKA PESAN DITAMPILKAN
    }
    return null;
  }

  String validateKecamatan(String value) {
    if (value.isEmpty) {
      //JIKA VALUE KOSONG
      return 'Kecamatan Harus Diisi'; //MAKA PESAN DITAMPILKAN
    }
    return null;
  }

  String validateAgama(String value) {
    if (value.isEmpty) {
      //JIKA VALUE KOSONG
      return 'Agama Harus Diisi'; //MAKA PESAN DITAMPILKAN
    }
    return null;
  }

  String validateStatusKawin(String value) {
    if (value.isEmpty) {
      //JIKA VALUE KOSONG
      return 'Status Perkawinan Harus Diisi'; //MAKA PESAN DITAMPILKAN
    }
    return null;
  }

  String validatePekerjaan(String value) {
    if (value.isEmpty) {
      //JIKA VALUE KOSONG
      return 'Pekerjaan Harus Diisi'; //MAKA PESAN DITAMPILKAN
    }
    return null;
  }

  String validateWargaNegara(String value) {
    if (value.isEmpty) {
      //JIKA VALUE KOSONG
      return 'Kewarganegaraan Harus Diisi'; //MAKA PESAN DITAMPILKAN
    }
    return null;
  }

  String validateTypeBarang(String value) {
    if (value.isEmpty) {
      //JIKA VALUE KOSONG
      return 'Type Barang/Varian Barang'; //MAKA PESAN DITAMPILKAN
    }
    return null;
  }

  String validateHargaJual(String value) {
    if (value.isEmpty) {
      //JIKA VALUE KOSONG
      return 'Harga Jual harus diisi'; //MAKA PESAN DITAMPILKAN
    }
    return null;
  }

  String validatePinjaman(String value) {
    if (value.isEmpty) {
      //JIKA VALUE KOSONG
      return 'Jumlah Pinjaman harus diisi ';
    }
    return null;
  }

  String validateNettoBarang(String value) {
    if (value.isEmpty) {
      //JIKA VALUE KOSONG
      return 'Berat bersih harus diisi';
    }
    return null;
  }

  String validateKadarEmas(String value) {
    if (value.isEmpty) {
      return 'Kadar Emas harus diisi ';
    }

    if (double.parse(value) > 24) {
      return 'Isi antara 10 - 24 Karat';
    }
    return null;
  }

  String validatePinjamanMax(String value) {
    if (value.isEmpty) {
      return 'Data belum lengkap terisi';
    }

    return null;
  }
}
