#=
Convenience routines for generating and manipulating file names
=#
using Pkg: project

# ——————————————————————— Generation and versionization of paths ——————————————————————— #
"""Absolute path of current active project (folder containing `Project.toml`)"""
const PROJECT_ROOT = dirname(project().path)

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
