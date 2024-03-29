#=
Convenience routines for generating and manipulating file names
=#
using Pkg: project

# ——————————————————————— Generation and versionization of paths ——————————————————————— #
# TODO: Once all our projects are julia >1.8, we can make this at least a typed global
"""Absolute path of current active project (folder containing `Project.toml`) at
the time of including `using PConv`"""
PROJECT_ROOT = ""

"""
    dirnames(n::Integer, path::AbstractString)

Extend Base.dirname function to direcly apply it n-times
"""
function dirnames(n::Integer, path::AbstractString)
    n < 1 && error("Invalid depth!")
    return ∘(fill(dirname, n)...)(path)
end

"""
    find_project_root(folder_path::AbstractString)

Find the root-path of project by searching for first `Project.toml` above/equal folder_path.
"""
function find_project_root(folder_path::AbstractString)
    !isdir(folder_path) && error("find_project_root: folder_path is not a folder!")

    goal = "Project.toml"
    maxiter = (length ∘ split)(folder_path, "/") - 1 # Check maximal iteration depth

    for i in 1:maxiter
        files = filter(isfile, readdir(folder_path; join = true))
        file_names = map(x -> split(x, "/")[end], files)

        goal ∈ file_names && return folder_path
        folder_path = dirname(folder_path)
    end

    error("find_project_root: Project folder not found!")
    return ""
end

"""
    versionized_path(filename; abspath=PROJECT_ROOT, overwrite = false)

Generate versionized path*filename by appending _vx to the filename if filename already exists.

# Arguments
- `filename::AbstractString:` Folder+name of the file with file extension (Example "pictures/test.png")
- `abspath::AbstractString=PROJECT_ROOT:` Absolute path to use. Default is the
directory of the active project.
- `overwrite::Bool` If `false`, don't versionize the path and potentially overwrite existing
file
- `return:` versionized_path::AbstractString
"""
function versionized_path(filename; abspath::AbstractString = PROJECT_ROOT,
                          overwrite::Bool = false)
    # Bring filename and abspath intor correct "/"-formar
    if filename[1] == '/'
        filename = filename[2:end]
    end

    if abspath[end] == '/'
        abspath = abspath[1:(end-1)]
    end

    path = abspath * "/" * filename

    if overwrite
        return path

    else # Generate versionized file name
        # Extract filetype
        filetype = ""
        for i in length(filename):-1:1
            # Start from the end and search for first dot
            # Everything after this dot is the file extension
            if filename[i] == '.'
                filetype = filename[i:end]
                break
            end
        end

        version, versionstring = 0, ""
        while isfile(path)
            # Generate a file with a version name!
            version += 1
            temp = path[begin:(end - length(filetype) - length(versionstring))]
            versionstring = "_v$version"
            path = temp * versionstring * filetype
        end

        return path
    end
end

# ——————————————————————————————————— Printing utils ——————————————————————————————————— #
"""
    overprint(str::AbstractString)

Replace current line with str, i.e. overprint current line.
"""
function overprint(str::AbstractString)
    print("\u1b[1F")
    #Moves cursor to beginning of the line n (default 1) lines up
    print(str)   #prints the new line
    print("\u1b[0K")
    # clears  part of the line.
    #If n is 0 (or missing), clear from cursor to the end of the line.
    #If n is 1, clear from cursor to beginning of the line.
    #If n is 2, clear entire line.
    #Cursor position does not change.

    println() #prints a new line, i really don't like this arcane codes
end

# ———————————————————————————————— Preproccessed include ——————————————————————————————— #

""" Truncate file below given delimiter. Default behavior for pinclude"""
truncate_below(delim) = x -> split(x, delim)[1]

"""
    pinclude(fname::AbstractString, preprocess_code::Function)
    pinclude(fname::AbstractString, delim::AbstractString)

Preprocessed include function. Before the code is included in the current scope,
`preprocess_code(code)` is called to allow for modifications. If a string is supplied, the
specified file is only included up to the specified delimiter, e.g. `##-`.
"""
function pinclude(fname::AbstractString, preprocess_code::Function)
    isa(fname, String) || (fname = Base.convert(String, fname)::String)
    _pinclude(identity, Main, fname, preprocess_code)
end

function pinclude(fname::AbstractString, delim::AbstractString)
    isa(fname, String) || (fname = Base.convert(String, fname)::String)
    _pinclude(identity, Main, fname, truncate_below(delim))
end

# @noinline Workaround for module availability in _simplify_include_frames
@noinline function _pinclude(mapexpr::Function, mod::Module, _path::AbstractString, preprocess_code::Function)
    path, prev = Base._include_dependency(mod, _path)

    # Process the code of the file
    _code = read(path, String)
    code = preprocess_code(_code)

    tls = task_local_storage()
    tls[:SOURCE_PATH] = path
    try
        return include_string(mapexpr, mod, code, path)
    finally
        if prev === nothing
            delete!(tls, :SOURCE_PATH)
        else
            tls[:SOURCE_PATH] = prev
        end
    end
end

"""
    rinclude(fname::AbstractString)

Include with filepath relative to content root instead of relative path.
"""
function rinclude(fname::AbstractString)
    isa(fname, String) || (fname = Base.convert(String, fname)::String)

    if contains(fname, "..") # use relative path
        path = fname
    else # make absolute path relative to content root
        path = joinpath(PROJECT_ROOT, fname)
    end

    Base._include(identity, Main, path)
end
