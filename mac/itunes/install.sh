echo "Install iTunes controller"

git clone https://github.com/qgadrian/itunes_controller.git

cargo build --release --manifest-path ./itunes_controller

mv itunes_controller/target/release/itunes /usr/local/bin/
