export PREFIX="$HOME/opt/cross/$TARGET"
export TARGET=x86_64-elf
export PATH="$PREFIX/bin:$PATH"

mkdir build
cd build

mkdir build-binutils build-gdb build-gcc

wget https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.gz
wget https://ftp.gnu.org/gnu/gdb/gdb-14.1.tar.gz
wget https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.gz

tar -xvf binutils-2.41.tar.gz
tar -xvf gdb-14.1.tar.gz
tar -xvf gcc-13.2.0.tar.gz

cd build-binutils
../binutils-2.41/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make -j8
make install

cd ../build-gdb
../gdb-14.1/configure --target=$TARGET --prefix="$PREFIX" --disable-werror
make all-gdb -j8
make install-gdb

cat > ../gcc-13.2.0/gcc/config/i386/t-x86_64-elf << EOF
#Add libgcc multilib variant without red-zone requirement
MULTILIB_OPTIONS += mno-red-zone
MULTILIB_DIRNAMES += no-red-zone
EOF

cd ../build-gcc
../gcc-13.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc -j8
make all-target-libgcc -j8
make install-gcc
make install-target-libgcc