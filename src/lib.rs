use spiget::model::*;
use spiget::SpigetClient;

fn client() -> SpigetClient {
    SpigetClient::new("https://api.spiget.org/v2")
}

pub async fn search(query: &str) {
    let client = client();

    let response = client
        .get_search_resources_by_query(query)
        .field("your field")
        .fields("your fields")
        .page(1.0)
        .size(1.0)
        .sort("your sort")
        .await
        .unwrap();
}
