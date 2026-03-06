use std::ffi::CString;
use std::os::raw::c_char;
use ulid::Ulid;

#[unsafe(no_mangle)]
pub extern "C" fn generate_ulid_string() -> *mut c_char {
    let s = Ulid::new().to_string();
    CString::new(s).unwrap().into_raw()
}

#[unsafe(no_mangle)]
pub extern "C" fn free_ulid_string(ptr: *mut c_char) {
    if !ptr.is_null() {
        unsafe { let _ = CString::from_raw(ptr); }
    }
}