//!
//! PLugins nOW! A simple plugin manager
//!

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = std::env::args().collect::<Vec<String>>();
    let Some(subcommand) = args.get(1) else {
        show_usage(true);
        unreachable!()
    };

    match subcommand.to_lowercase().as_str() {
        "search" => todo!(),
        "install" => todo!(),
        "uninstall" => todo!(),
        "reinstall" => todo!(),
        "tui" => todo!(),
        _ => {
            eprintln!("Unknown subcommand: {}", subcommand);
            show_usage(true);
        }
    }

    Ok(())
}

fn show_usage(exit: bool) {
    eprintln!(
        r#"Usage: plow <subcommand> <args>
Subcommands:
    - `search <query>`
    Search for plugins

    - `install <plugin> @<version>`
    Install a plugin

    - `uninstall <plugin>`
    Uninstall a plugin

    - `reinstall <plugin> @<version>`
    Uninstall and reinstall a plugin

    - `tui`
    Run an interactive version of the app.
"#
    );

    if exit {
        std::process::exit(1);
    }
}
