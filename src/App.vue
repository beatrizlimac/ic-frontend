<template>
  <div id="app">
    <h1>Busca de Operadoras</h1>
    <input
      v-model="searchTerm"
      placeholder="Digite o termo para busca..."
      @keyup.enter="search"
    />
    <button @click="search">Buscar</button>
    <div v-if="errorMessage" class="error">{{ errorMessage }}</div>
    <div v-if="loading">Carregando...</div>
    <div v-if="results.length">
      <h2>Resultados</h2>
      <ul>
        <li v-for="(item, index) in results" :key="index">
          <p><strong>Registro ANS:</strong> {{ item.registro_ans }}</p>
          <p><strong>CNPJ:</strong> {{ item.cnpj }}</p>
          <p><strong>Razão Social:</strong> {{ item.razao_social }}</p>
          <p><strong>Nome Fantasia:</strong> {{ item.nome_fantasia }}</p>
          <p><strong>Modalidade:</strong> {{ item.modalidade }}</p>
          <p>
            <strong>Endereço:</strong>
            {{ item.logradouro }}, {{ item.numero }} - {{ item.complemento }}
          </p>
          <p><strong>Bairro:</strong> {{ item.bairro }}</p>
          <p><strong>Cidade:</strong> {{ item.cidade }}</p>
          <p><strong>UF:</strong> {{ item.uf }}</p>
          <p><strong>CEP:</strong> {{ item.cep }}</p>
          <p><strong>DDD:</strong> {{ item.ddd }}</p>
          <p><strong>Telefone:</strong> {{ item.telefone }}</p>
          <p><strong>Fax:</strong> {{ item.fax }}</p>
          <p><strong>Email:</strong> {{ item.endereco_eletronico }}</p>
          <p><strong>Representante:</strong> {{ item.representante }}</p>
          <p>
            <strong>Cargo do Representante:</strong>
            {{ item.cargo_representante }}
          </p>
          <p>
            <strong>Região de Comercialização:</strong>
            {{ item.regiao_da_comercializacao }}
          </p>
        </li>
      </ul>
    </div>
    <div v-else-if="!loading && searchPerformed && !errorMessage">
      Nenhum resultado encontrado.
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const searchTerm = ref('')
const results = ref([])
const loading = ref(false)
const errorMessage = ref('')
const searchPerformed = ref(false)

async function search() {
  if (!searchTerm.value.trim()) {
    errorMessage.value = "Por favor, digite um termo para busca."
    return
  }
  errorMessage.value = ''
  loading.value = true
  searchPerformed.value = false
  try {
    const response = await fetch(`http://localhost:5001/?q=${encodeURIComponent(searchTerm.value)}`)
    if (!response.ok) {
      const errorData = await response.json()
      errorMessage.value = errorData.error || "Erro na busca."
      results.value = []
    } else {
      results.value = await response.json()
    }
  } catch (error) {
    errorMessage.value = "Erro ao conectar com a API."
    results.value = []
  } finally {
    loading.value = false
    searchPerformed.value = true
  }
}
</script>

<style scoped>
.error {
  color: red;
}
input {
  margin-right: 8px;
  padding: 4px;
}
button {
  padding: 4px 8px;
}
ul {
  list-style: none;
  padding: 0;
}
li {
  border: 1px solid #ccc;
  padding: 8px;
  margin-bottom: 10px;
}
</style>
