
local function install_query(type, path)
  local query_path = path .. "/queries/" .. type .. ".scm"
  local conf_path = vim.fn.stdpath("config")
  vim.uv.fs_mkdir(conf_path .. "/queries", 511, function(err, success)
    if err then
      print(err)
    else
      vim.uv.fs_symlink(query_path, conf_path .. "/queries/" .. type .. ".scm", {})
    end
  end)
end
