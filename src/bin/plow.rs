//!
//! PLugins nOW! A simple plugin manager
//!

use std::process::exit;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = std::env::args().collect::<Vec<String>>();
    let Some(subcommand) = args.get(1) else {
        show_usage()
    };

    let rest = &args[2..];

    match subcommand.to_lowercase().as_str() {
        "search" => search(rest).await,
        "install" => todo!(),
        "uninstall" => todo!(),
        "reinstall" => todo!(),
        "tui" => todo!(),
        _ => {
            eprintln!("Unknown subcommand: {}", subcommand);
            show_usage();
        }
    }

    Ok(())
}

async fn search(args: &[String]) {
    let Some(query) = args.get(0) else {
        eprintln!("Missing query!");
        exit(1);
    };

    plow::search(query).await;
}

fn show_usage() -> ! {
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

    exit(1);
}
