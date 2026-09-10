void main() {
  //Menyimpan daftar harga (built-in type (map))
  Map<String,int> daftarHarga ={
    'Beras'         : 12000,
    'Gula'          : 15000,
    'Minyak Goreng' : 18000,
    'Telur'         : 27000,
    'Susu'          : 20000,
  } ;
  
  print('======== DARTAR HARGA ========');
  for (var item in daftarHarga.entries){
    print('${item.key}    : ${item.value}');
  }
  print('\n');
  
  //Menyimpan daftar belanjaan (function)
  List<Map<String, dynamic>> keranjang = [];
  
  print('======== BELANJAAN ========');
  keranjang = addKeranjang(keranjang, daftarHarga, 'Beras', 2);
  keranjang = addKeranjang(keranjang, daftarHarga, 'Gula', 3);
  keranjang = addKeranjang(keranjang, daftarHarga, 'Telur', 1);
  keranjang = addKeranjang(keranjang, daftarHarga, 'Susu', 4);
  
  
  //Menentukan case diskon (if/else if/else)
  int totalBelanja = 0;
  for (var item in keranjang) {
    totalBelanja += item['subtotal'] as int;
  }
  print('Total Belanja : Rp$totalBelanja');
  print('\n');

  double diskon;
  if (totalBelanja >= 200000) {
    diskon = 0.20;
  } else if (totalBelanja >= 100000) {
    diskon = 0.10;
  } else if (totalBelanja >= 50000) {
    diskon = 0.05; 
  } else {
    diskon = 0.0; 
  }
  
  //Total akhir belanjaan
  int nilaiPotongan = (totalBelanja * diskon).round();
  int totalAkhir    = totalBelanja - nilaiPotongan;
  
  print("======== TOTAL BELANJAAN (+ Diskon ) =========");
  print('Diskon yang didapat : ${(diskon * 100)}%');
  print('Nilai potongan  : Rp$nilaiPotongan');
  
  if (totalAkhir < totalBelanja) {
    print('Total akhir setelah diskon : Rp$totalAkhir');
  } else {
    print('Total akhir (tidak ada diskon) : Rp$totalAkhir');
  }
  
}

// ==== addKeranjang FUNCTION =====
List<Map<String, dynamic>> addKeranjang(
  List<Map<String, dynamic>> keranjang,
  Map<String, int> daftarHarga,
  String nama,
  int jumlah,
) {
  if (daftarHarga.containsKey(nama)) {
    int harga    = daftarHarga[nama]!;
    int subtotal = harga * jumlah;
    keranjang.add({
      'nama': nama,
      'jumlah': jumlah,
      'harga': harga,
      'subtotal': subtotal,
    });
    print('$nama x$jumlah : Rp$subtotal');
  } else {
    print('Barang "$nama" tidak ditemukan di daftar harga!');
  }
  return keranjang;
}