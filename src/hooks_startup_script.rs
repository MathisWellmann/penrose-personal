use penrose::{
    core::{
        hooks::Hook,
        manager::WindowManager,
        xconnection::{XConn},
    },
    Result,
};

pub struct StartupScript {
    path: String,
}
impl StartupScript {
    pub fn new(s: impl Into<String>) -> Self {
        Self { path: s.into() }
    }
}

impl<X: XConn> Hook<X> for StartupScript {
    fn startup(&mut self, _: &mut WindowManager<X>) -> Result<()> {
        spawn!(&self.path)
    }
}
