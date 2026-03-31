window.addEventListener('turbo:load', () => {
   console.log("JS読み込み成功");
  const priceInput = document.getElementById("item-price");
  
  if (!priceInput) return;
  
  
  priceInput.addEventListener("input", () => {
    const inputValue = priceInput.value;
    const addTaxDom = document.getElementById("add-tax-price");
    const profitDom = document.getElementById("profit");

    // 手数料（10%）の計算（小数点以下は切り捨て）
    const tax = Math.floor(inputValue * 0.1);
    addTaxDom.innerHTML = tax.toLocaleString();

    // 販売利益の計算
    const profit = inputValue - tax;
    profitDom.innerHTML = profit.toLocaleString();
  })
});
